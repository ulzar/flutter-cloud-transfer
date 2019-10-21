// Copyright 2018 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';
import 'dart:io';
import 'dart:wasm';
import 'package:uuid/uuid.dart';
import 'dart:isolate';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:english_words/english_words.dart';
import 'package:grpc/grpc.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'src/generated/sirius/services/service.pbgrpc.dart' as siriusSvc;
import 'src/generated/sirius/types/file.pbenum.dart' as siriusTypes;


const atheraJWT = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6Ik9UUkdPVGczTXpCRFJEWXpSVE00TVVNd09USkJNRGMwT1RGRE5VWXdSRVl4TWtORk56YzJOUSJ9.eyJodHRwczovL21ldGFkYXRhLmVsYXJhLmlvL2luZm8iOnsiYXV0aElkIjoiYXV0aDB8NWFlMDczNGU3MzY0ZWQzYzI5ZWExYmY0IiwiZWxhcmFVc2VySWQiOiI2ZjIwNmRkYy0yMzdjLTRjNTUtYjMyNC0yZDI2NmVjOTgwNDkiLCJhdXRoMF9pZCI6ImF1dGgwfDVhZTA3MzRlNzM2NGVkM2MyOWVhMWJmNCIsImVsYXJhX3VzZXJfaWQiOiI2ZjIwNmRkYy0yMzdjLTRjNTUtYjMyNC0yZDI2NmVjOTgwNDkifSwiaXNzIjoiaHR0cHM6Ly9pZC5hdGhlcmEuaW8vIiwic3ViIjoiYXV0aDB8NWFlMDczNGU3MzY0ZWQzYzI5ZWExYmY0IiwiYXVkIjoiaHR0cHM6Ly9wdWJsaWMuYXRoZXJhLmlvIiwiaWF0IjoxNTcxNjQ0MDQzLCJleHAiOjE1NzE3MzA0NDMsImF6cCI6Ik41Qng0eDZUb0tDQk01Q0hBVjlPNWVOYjdpR01uczhUIiwic2NvcGUiOiJvZmZsaW5lX2FjY2VzcyJ9.XeU6rtXhMbsq1PUeqzH0JWxOWuwLmF1H--2IhnCV6XRbVo667cnRflMvzWIWcjoNQzGfAFtbaL1T5cmgb0L_lK5uJcVXCDE3U3WzPqNSgbfAehqL5FgM2flri4Kno_YrMiIRu6yUjWQFgX72szwniH05JRr64-mpa5sHKsu6esIBwPBmSuDbaKLZ6wl0FubcXbCebjW9br9Xv9RONtrV8X24dPdsSjkZDMEMYxyU7CdOLYR8btU8gqxI9qG10D9xEURF985qFYaElBP_9Y4CkfjkHfoX3Ig3y-tqSaiXGdCH1CycDViTekjQDuH5h9p_dF7eeHhAfqUGvi50l_7ajg';


Map<String, String> metadata = {
      'authorization': 'bearer: $atheraJWT',
      'active-group': 'ee2219fb-d877-4475-8c03-408feabdabb3'
    };

// [('authorization', "bearer: {}".format(self.token)),
//                     ('active-group', group_id)]

void main() {
  // See https://github.com/flutter/flutter/wiki/Desktop-shells#target-platform-override
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

  runApp(new MyApp());
}


ResponseStream<siriusSvc.FilesListResponse> listRemoteFiles(siriusSvc.SiriusClient siriusClient, String remoteFolderPath) {
    final request = siriusSvc.FilesListRequest();
    request..path = remoteFolderPath;
    request..mountId = '44e39b2f-ecb7-44d5-b9ea-c6ff98e84b8d';

    return siriusClient.filesList(request, options: CallOptions(metadata: metadata));
}

downloadFile(siriusSvc.SiriusClient siriusClient, File localFile, String remoteFilePath, publishProgress (int byteTransferred)) async {
    final request = siriusSvc.FileDownloadRequest();
    request..path = remoteFilePath;
    request..mountId = '44e39b2f-ecb7-44d5-b9ea-c6ff98e84b8d';
    int totalBytesWritten = 0;

    var streamController = new StreamController<siriusSvc.FileDownloadRequest>();
    streamController.add(request);

    await for (var fileDownloadResponse in siriusClient.fileDownload(streamController.stream, options: CallOptions(metadata: metadata))) {
      // fileDownloadResponse.bytes
      // if (fileDownloadResponse.bytesRemaining > 0) {
        localFile.writeAsBytes(fileDownloadResponse.bytes);
        publishProgress(fileDownloadResponse.bytes.length);
        totalBytesWritten += fileDownloadResponse.bytes.length;
        streamController.add(request); // ACK
      // }
    }
    // print('File $remoteFilePath: wrote ${totalBytesWritten} bytes');
    streamController.close();
    return;
}

class CustomFile {
  bool _isFolder;
  String _parentFolderPath;
  String _filePath;
  String _name;
  CustomFile(
    bool isFolder, String filePath, String parentFolderPath
  ) {
    _isFolder = isFolder;
    _filePath = filePath;
    _name = path.basename(filePath);
    _parentFolderPath = parentFolderPath;
  }
}

class InitTransferEvent {
  String transferID;
  String remoteFolderPath;
  String localFolderPath;
  bool isUpload = false;

  InitTransferEvent(this.transferID, this.remoteFolderPath, this.localFolderPath, this.isUpload);
}

class FileDownloadEvent {
  String transferID;
  int totalFileSize;

  FileDownloadEvent(this.transferID, this.totalFileSize);
}

class FileDownloadProgressEvent {
  String transferID;
  int bytesTransferred = 0;

  FileDownloadProgressEvent(this.transferID, this.bytesTransferred);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    EventBus eventBus = new EventBus();
    return MaterialApp(
      title: 'File Transfer',
      // theme: ThemeData(
      //   primaryColor: Colors.amber,
      // ),
      home: MyHomePage(title: 'Flutter Demo Home Page', eventBus: eventBus,),
      routes: <String, WidgetBuilder>{
        '/transfers': (context) => TransferScreen(eventBus)
      },
    );
  }
}

class TransferScreen extends StatefulWidget {
  EventBus _eventBus;
  TransferScreen(EventBus bus) {
    _eventBus = bus;
  }
  @override
  TransferScreenState createState() => TransferScreenState(_eventBus);
  
}

class TransferScreenState extends State<TransferScreen> {
  EventBus _eventBus;
  String currentTransferID;
  String transferType;
  String currentRemoteFolderPath;
  String currentLocalFolderPath;
  int totalBytes = 0;
  int bytesTransferred = 0;



  TransferScreenState(EventBus eventBus) {
    _eventBus = eventBus;
  }

  @override
  Widget initState() {
    super.initState();
    _eventBus.on<InitTransferEvent>().listen(
      (event) {
        print('Received InitTransferEvent: $event');
        totalBytes = 0;
        bytesTransferred = 0;
        currentTransferID = event.transferID;
        transferType = 'Download';
        if (event.isUpload) {
          transferType = 'Upload';
        }
        currentRemoteFolderPath = event.remoteFolderPath;
        currentLocalFolderPath = event.localFolderPath;
      }
    );

    _eventBus.on<FileDownloadEvent>().listen(
      (event) {
        print('Received FileDownloadEvent: $event');
        if (event.transferID != currentTransferID) {
          print('Wrong transfer ID, event ignored');
        }
        totalBytes += event.totalFileSize;
      }
    );
    _eventBus.on<FileDownloadProgressEvent>().listen(
      (event) {
        print('Received FileDownloadProgressEvent: $event');
        if (event.transferID != currentTransferID) {
          print('Wrong transfer ID, event ignored');
        }
        bytesTransferred += event.bytesTransferred;
      }
    );
  }

  // getPercentage get 

  double get currentPercentage {
    if (totalBytes == 0) {
      return 0;
    }
    return bytesTransferred/totalBytes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transfer: $transferType"),
      ),
      body: Container(
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  'LocalFolderPath: $currentLocalFolderPath'
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'RemoteFolderPath: $currentRemoteFolderPath'
                ),
              ),
              Expanded(
                flex: 1,
                child: LinearProgressIndicator(
                backgroundColor: Colors.white,
                value: currentPercentage 
                ),
              ),
            ],
          )
        ],)
      )
      // body: Center(
      //   child: RaisedButton(
      //     onPressed: () {
      //       // Navigate back to first screen when tapped.
      //       Navigator.pop(context);
      //     },
      //     child: Text('Go back!'),
      //   ),
      // ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.eventBus}) : super(key: key);
  final String title;

  EventBus eventBus;
  

  @override
  _MyHomePageState createState() => _MyHomePageState(eventBus);
}

class _MyHomePageState extends State<MyHomePage> {

  EventBus _eventBus;
  _MyHomePageState(EventBus bus) {
    _eventBus = bus;
  }

  @override
  Widget build(BuildContext context) {
    
    LocalExplorer localExplorer = new LocalExplorer(_eventBus);
    return Row(children: <Widget>[
      Expanded(
        child: localExplorer,
      ),
      Expanded(child: RemoteExplorer()),
      Container(
        width: 40, 
        color: Colors.grey,
        child: Card(child: IconButton(
          icon: Icon(Icons.list), 
          onPressed: () {
            Navigator.pushNamed(context, '/transfers');
          }
        )),
        ),
    ]);
  }
}

// **************************************************************************************************
// **************************************************************************************************
// **************************************************************************************************
class RemoteExplorer extends StatefulWidget {
  @override
  RemoteExplorerState createState() => RemoteExplorerState();
}

class RemoteExplorerState extends State<RemoteExplorer> {
  List<CustomFile> _suggestions = <CustomFile>[];
  // final Set<WordPair> _saved = Set<WordPair>();   // Add this line.
  final TextStyle _biggerFont = TextStyle(fontSize: 18.0);
  siriusSvc.SiriusClient siriusClient;

  // Directory _parentDirectory = Directory('/workspace/dump');
  String _currentDirectoryPath = '/';

  @override
  Widget initState() {
    super.initState();
    final channel = ClientChannel('europe-west1.files.athera.io',
        port: 443,
        // options:
        //     const ChannelOptions(credentials: ChannelCredentials.insecure())
    );
    siriusClient = siriusSvc.SiriusClient(channel);  
    
    listFiles('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Remote Folder Explorer'),
        // actions: <Widget>[
        //   IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        // ],
      ),
      body: Container(
            child: Column(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_upward),
                      onPressed: () {
                        listFiles(path.dirname(_currentDirectoryPath));
                      },
                    )
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      _currentDirectoryPath,
                      textAlign: TextAlign.left,
                    ),
                  )
                ]
              ),
          Expanded(
            child: new LayoutBuilder(builder: (layoutContext, constraint) {
              return ListView.separated(
                  separatorBuilder: (context, i) {
                    return Divider();
                  },
                  itemCount: _suggestions.length,
                  padding: const EdgeInsets.all(16.0),
                  itemBuilder: /*1*/ (context, i) {
                    return _buildRow(_suggestions[i], i, layoutContext, constraint);
                  }
              );
            }),
          )
        ])
      )
      // body: new LayoutBuilder(builder: (layoutContext, constraint) {
      //   return ListView.separated(
      //       separatorBuilder: (context, i) {
      //         return Divider();
      //       },
      //       itemCount: _suggestions.length,
      //       padding: const EdgeInsets.all(16.0),
      //       itemBuilder: /*1*/ (context, i) {
      //         return _buildRow(_suggestions[i], i, layoutContext, constraint);
      //       }
      //   );
      // }),
    );
  }

  Future<List<FileSystemEntity>> listFiles(String remotePath) async {
    _currentDirectoryPath = remotePath;
    // print('List path : $remotePath');
    final List<CustomFile> tmp_suggestions = <CustomFile>[];
    
    await for (var fileListResponse in listRemoteFiles(siriusClient, remotePath)) {
      final file = fileListResponse.file;
      if (file.type == siriusTypes.File_Type.DIRECTORY) {
        tmp_suggestions.add(new CustomFile(
          true, file.path, remotePath
        ));
      }
    }

    setState(() {
      _suggestions = tmp_suggestions;
      // print("File List: list on done" + _suggestions.toString());
    });
  }

  // Future<List<FileSystemEntity>> fileDownload(String remotePath) async {
  //   _currentDirectoryPath = remotePath;
  //   print('FileDownload : $remotePath');
  //   final List<CustomFile> tmp_suggestions = <CustomFile>[];
    
  //   await for (var fileListResponse in listRemoteFiles(siriusClient, remotePath)) {
  //     final file = fileListResponse.file;
  //     if (file.type == siriusTypes.File_Type.DIRECTORY) {
  //       tmp_suggestions.add(new CustomFile(
  //         true, file.path, remotePath
  //       ));
  //     }
  //   }

  //   setState(() {
  //     _suggestions = tmp_suggestions;
  //     print("File List: list on done" + _suggestions.toString());
  //   });
  // }



  Widget _buildRow(
      CustomFile remoteFolder, int index, layoutContext, constraint) {
    var listTileWord = ListTile(
      title: Text(
        remoteFolder._name,
        style: _biggerFont,
      ),
      onTap: () {
        setState(() {
          listFiles(remoteFolder._filePath);
        });
      },
    );
    return LongPressDraggable(
      key: new ObjectKey(index),
      data: remoteFolder,
      child: new DragTarget<FileSystemEntity>(
        builder: (BuildContext context, List<FileSystemEntity> data,
            List<dynamic> rejects) {
          return new Card(
            child: new Column(
              children: <Widget>[
                listTileWord,
              ],
            ),
          );
        },
        onWillAccept: (data) {
          return true;
        },
        onAccept: (data) {
          Scaffold.of(layoutContext).showSnackBar(new SnackBar(
            content:
                new Text(remoteFolder._filePath + " Received folder " + data.path),
          ));
        },
      ),
      onDragStarted: () {
        Scaffold.of(layoutContext).showSnackBar(new SnackBar(
          content: new Text("Drag the row onto another row to change places"),
        ));
      },
      feedback: new SizedBox(
        width: constraint.maxWidth,
        child: new Card(
          child: new Column(
            children: <Widget>[listTileWord],
          ),
        ),
      ),
      childWhenDragging: Container(),
    );
  }
}

// **************************************************************************************************
// **************************************************************************************************
// **************************************************************************************************
class LocalExplorer extends StatefulWidget {

  EventBus eventBus;
  LocalExplorer(EventBus eventBus) {
    eventBus = eventBus;
  }
  @override
  LocalExplorerState createState() => LocalExplorerState(eventBus);
}

class LocalExplorerState extends State<LocalExplorer> {
  final List<FileSystemEntity> _suggestions = <FileSystemEntity>[];
  // final Set<WordPair> _saved = Set<WordPair>();   // Add this line.
  final TextStyle _biggerFont = TextStyle(fontSize: 18.0);
  EventBus _eventBus;
  Directory _parentDirectory = Directory('/workspace/dump');
  siriusSvc.SiriusClient _siriusClient;

  LocalExplorerState(EventBus eventBus) {
    _eventBus = eventBus;
  }

  @override
  Widget initState() {
    super.initState();
    final channel = ClientChannel('europe-west1.files.athera.io', port: 443);
    _siriusClient = siriusSvc.SiriusClient(channel); 
    dirContents(_parentDirectory);
  }

  File openLocalFile(folderPath, filename) {
    return File('$folderPath/$filename');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Local Folder Explorer'),
        ),
        body: Container(
            child: Column(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_upward),
                      onPressed: () {
                        dirContents(_parentDirectory.parent);
                      },
                    )
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      _parentDirectory.path,
                      textAlign: TextAlign.left,
                    ),
                  )
                ]
              ),
          Expanded(
            child: new LayoutBuilder(builder: (layoutContext, constraint) {
              return _buildSuggestions(layoutContext, constraint);
            }),
          )
        ]))
    );
  }

  Widget _buildSuggestions(layoutContext, constraint) {
    return ListView.separated(
        separatorBuilder: (context, i) {
          return Divider();
        },
        itemCount: _suggestions.length,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          return _buildRow(_suggestions[i], i, layoutContext, constraint);
        }
    );
  }

  Future<List<FileSystemEntity>> dirContents(Directory dir) {
    var lister = dir.list(recursive: false);
    _suggestions.clear();
    _parentDirectory = dir;

    lister.listen(
        (file) => {
              file.stat().then((fileStat) {
                if (fileStat.type == FileSystemEntityType.directory) {
                  _suggestions.add(file);
                  print(
                      'Added file ${file.path} to _suggestions (${_suggestions.length})');
                }
              })
            },
        // should also register onError
        onDone: () => {
              setState(() {
                print("list on done" + _suggestions.toString());
              })
            });
  }

  downloadFiles(String localFolderPath, String remoteFolderPath) async {
    print('Downloading files from $remoteFolderPath to $localFolderPath');
    // bool foundFile = false;
    var futures = <Future>[];
    var now = new DateTime.now();
    var transferID = Uuid().v4().toString();
    _eventBus.fire(new InitTransferEvent(transferID, remoteFolderPath, localFolderPath, false));
    await for (var fileListResponse in listRemoteFiles(_siriusClient, remoteFolderPath)) {
      final file = fileListResponse.file;
      if (file.type != siriusTypes.File_Type.DIRECTORY) {
        _eventBus.fire(new FileDownloadEvent(transferID, file.size.toInt()));
        final localFile = openLocalFile(localFolderPath, file.name);
        var publishProgress = (int bytesTransferred) {
          _eventBus.fire(new FileDownloadProgressEvent(transferID, bytesTransferred));
        };
        futures.add(downloadFile(_siriusClient, localFile, file.path, publishProgress));
        
      }
    }
    await Future.wait(futures);
    var duration = DateTime.now().difference(now).inSeconds;
    print('Download took $duration secs');

  }

  Widget _buildRow(
      FileSystemEntity localFolder, int index, layoutContext, constraint) {
    // final bool alreadySaved = _saved.contains(pair);
    var listTileWord = ListTile(
      title: Text(
        path.basename(localFolder.path),
        style: _biggerFont,
      ),
      // trailing: Icon(   // Add the lines from here...
      //   alreadySaved ? Icons.favorite : Icons.favorite_border,
      //   color: alreadySaved ? Colors.red : null,
      // ),
      onTap: () {
        setState(() {
          dirContents(localFolder);
        });
      },
    );
    return LongPressDraggable(
      key: new ObjectKey(index),
      data: localFolder,
      child: new DragTarget<CustomFile>(
        builder: (BuildContext context, List<CustomFile> data, List<dynamic> rejects) {
          return new Card(
            child: new Column(
              children: <Widget>[
                listTileWord,
              ],
            ),
          );
        },
        onWillAccept: (remoteFolder) {
          print('onWillAccept');
          return true;
        },
        onAccept: (remoteFolder) {
          Scaffold.of(layoutContext).showSnackBar(new SnackBar(
            content: new Text("Receiving remote folder"),
          ));
          print('onAccept');
          print('Received remote folder: $remoteFolder');
          final myFile = openLocalFile(localFolder.path, remoteFolder._name);
          print('File to create $myFile');
          new Directory(path.join(localFolder.path, remoteFolder._name)).create()
          .then((Directory directory) {
            downloadFiles(directory.path, remoteFolder._filePath);
          });
          
        },
      ),
      onDragStarted: () {
        Scaffold.of(layoutContext).showSnackBar(new SnackBar(
          content: new Text("Drag the row onto another row to change places"),
        ));
      },
      feedback: new SizedBox(
        width: constraint.maxWidth,
        child: new Card(
          child: new Column(
            children: <Widget>[listTileWord],
          ),
        ),
      ),
      childWhenDragging: Container(),
    );
  }
}

// class RandomWordsState extends State<RandomWords> {
//   final List<WordPair> _suggestions = <WordPair>[];
//   final Set<WordPair> _saved = Set<WordPair>();   // Add this line.
//   final TextStyle _biggerFont = TextStyle(fontSize: 18.0);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Startup Name Generator'),
//         actions: <Widget>[
//           IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
//         ],
//       ),
//       body: _buildSuggestions(),
//     );
//   }

//   void _pushSaved() {
//     Navigator.of(context).push(
//       MaterialPageRoute<void>(
//         builder: (BuildContext context) {
//           final Iterable<ListTile> tiles = _saved.map(
//             (WordPair pair) {
//               return ListTile(
//                 title: Text(
//                   pair.asPascalCase,
//                   style: _biggerFont,
//                 )
//               );
//             }
//           );

//           final List<Widget> divided = ListTile
//           .divideTiles(
//             context: context,
//             tiles: tiles,
//           ).toList();

//           return Scaffold(
//             appBar: AppBar(
//               title: Text('Saved Suggestions')
//             ),
//             body: ListView(children: divided)
//           );
//         }
//       )
//     );
//   }

//   Widget _buildSuggestions() {
//     return ListView.builder(
//       padding: const EdgeInsets.all(16.0),
//       itemBuilder: /*1*/ (context, i) {
//         if (i.isOdd) return Divider(); /*2*/

//         final index = i ~/ 2; /*3*/
//         if (index >= _suggestions.length) {
//           _suggestions.addAll(generateWordPairs().take(10)); /*4*/
//         }
//         return _buildRow(_suggestions[index]);
//     });
//   }

//   Widget _buildRow(WordPair pair) {
//     final bool alreadySaved = _saved.contains(pair);
//     return ListTile(
//       title: Text(
//         pair.asPascalCase,
//         style: _biggerFont,
//       ),
//       trailing: Icon(   // Add the lines from here...
//         alreadySaved ? Icons.favorite : Icons.favorite_border,
//         color: alreadySaved ? Colors.red : null,
//       ),
//       onTap: () {
//         setState(() {
//           if(alreadySaved) {
//             _saved.remove(pair);
//           } else {
//             _saved.add(pair);
//           }
//         });
//       },
//     );
//   }
// }

// class RandomWords extends StatefulWidget {
//   @override
//   RandomWordsState createState() => RandomWordsState();
// }
