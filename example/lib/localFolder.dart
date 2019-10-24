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
import 'package:example_flutter/transfers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:path/path.dart' as path;
import 'commons.dart';
import 'src/generated/sirius/services/service.pbgrpc.dart' as siriusSvc;
import 'src/generated/sirius/types/file.pbenum.dart' as siriusTypes;


// **************************************************************************************************
// **************************************************************************************************
// **************************************************************************************************
class LocalExplorer extends StatefulWidget {

  @override
  LocalExplorerState createState() => LocalExplorerState();
}

class LocalExplorerState extends State<LocalExplorer> {
  final List<FileSystemEntity> _suggestions = <FileSystemEntity>[];
  // final Set<WordPair> _saved = Set<WordPair>();   // Add this line.
  final TextStyle _biggerFont = TextStyle(fontSize: 18.0);
  Directory _parentDirectory = Directory('/workspace/dump');
  siriusSvc.SiriusClient _siriusClient;


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
          child: Column(
            children: <Widget>[
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
            ]
          )
        )
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

  downloadFiles(String localFolderPath, String remoteFolderPath, TransferService transferSvc) async {
    print('Downloading files from $remoteFolderPath to $localFolderPath');
    // bool foundFile = false;
    // var futures = <Future>[];
    // var now = new DateTime.now();
    // globalEventBus.fire(InitTransferEvent(remoteFolderPath, localFolderPath, false));
    await for (var fileListResponse in listRemoteFiles(_siriusClient, remoteFolderPath)) {
      final remoteFile = fileListResponse.file;
      
      if (remoteFile.type != siriusTypes.File_Type.DIRECTORY) {
        transferSvc.newFileDownload(_siriusClient,remoteFile, localFolderPath);
        // globalEventBus.fire(FileDownloadEvent(transferID, file.size.toInt()));
        // final localFile = openLocalFile(localFolderPath, file.name);
        // var publishProgress = (int bytesTransferred) {
        //   globalEventBus.fire(FileDownloadProgressEvent(transferID, bytesTransferred));
        // };
        // futures.add(downloadFile(_siriusClient, localFile, file.path, publishProgress));
        
      }
    }
    // await Future.wait(futures);
    // var duration = DateTime.now().difference(now).inSeconds;
    // print('Download took $duration secs');

  }

  Widget _buildRow(
      FileSystemEntity localFolder, int index, layoutContext, constraint) {
    // final bool alreadySaved = _saved.contains(pair);
    final transferSvc = Provider.of<TransferService>(context);
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
          return true;
        },
        onAccept: (remoteFolder) {
          Scaffold.of(layoutContext).showSnackBar(new SnackBar(
            content: new Text("Receiving remote folder"),
          ));
          print('onAccept');
          print('Received remote folder: $remoteFolder');
          final myFile = openLocalFile(localFolder.path, remoteFolder.name);
          print('File to create $myFile');
          new Directory(path.join(localFolder.path, remoteFolder.name)).create()
          .then((Directory directory) {
            downloadFiles(directory.path, remoteFolder.filePath, transferSvc);
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
