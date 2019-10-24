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

// import 'package:event_bus/event_bus.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:event_bus/event_bus.dart';
import 'package:example_flutter/src/generated/sirius/services/service.pbgrpc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'commons.dart';
import 'package:path/path.dart' as path;

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/generated/sirius/types/file.pb.dart' as siriusTypes;


enum CounterEvent { 
  increment,
} // 1

class CounterBloc extends Bloc<CounterEvent, int> { // 2
  @override
  int get initialState => 0;

  @override
  Stream<int> mapEventToState(CounterEvent event) async* {
    switch (event) {
      case CounterEvent.increment:
        yield state + 1;
        break;
    }
  }
}

class TransferScreen extends StatefulWidget {

  @override
  TransferScreenState createState() => TransferScreenState();
  
}

enum DisplayFilter { all, download, upload}
// Check this link https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple
// Remove logic from TransferScreen and put it in a Change Notifier

class TransferScreenState extends State<TransferScreen> {
  // String currentTransferID;
  // String transferType;
  // String currentRemoteFolderPath;
  // String currentLocalFolderPath;
  // int totalBytes = 0;
  // int bytesTransferred = 0;
  final TextStyle _biggerFont = TextStyle(fontSize: 18.0);
  
  DisplayFilter _displayFilter = DisplayFilter.all;

  @override
  Widget build(BuildContext context) {
    final transferSvc = Provider.of<TransferService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Transfer. Download rate (${transferSvc.downloadRate}) / ${transferSvc.fileTransfers.length}"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[     
                Expanded(
                  flex: 1,
                  child: new LayoutBuilder(builder: (layoutContext, constraint) {
                    return _buildFileList(layoutContext, constraint, transferSvc);
                  }),
                )
              ],
          ),
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text("Transfer. Download rate (${transferSvc.downloadRate}) / ${transferSvc.fileTransfers.length}"),
    //   ),
    //   body: Container(
    //     child: Column(
    //       children: <Widget>[
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: <Widget>[
    //             Expanded(
    //               flex: 1,
    //               child: RadioListTile<DisplayFilter>(
    //                 title: FlatButton(
    //                   color: Colors.red,
    //                   child: Icon(Icons.filter_list),
    //                   onPressed: null,
    //                 ),
    //                 value: DisplayFilter.all,
    //                 groupValue: _displayFilter,
    //                 onChanged: (value) { setState(() { _displayFilter = value; }); }
    //               ),
    //             ),
    //             Expanded(
    //               flex: 1,
    //               child: RadioListTile<DisplayFilter>(
    //                 title: FlatButton.icon(
    //                   padding: const EdgeInsets.all(16.0),
    //                   color: Colors.red,
    //                   onPressed: null,
    //                   icon: Icon(Icons.filter_list),
    //                   label:Text('Download'),
    //                 ),
    //                 value: DisplayFilter.download,
    //                 groupValue: _displayFilter,
    //                 onChanged: (value) { setState(() { _displayFilter = value; }); }
    //               ),
    //             ),
    //             Expanded(
    //               child: RadioListTile<DisplayFilter>(
    //                 title: FlatButton.icon(
    //                   onPressed: null,
    //                   color: Colors.red,
    //                   icon: Icon(Icons.filter_list),
    //                   label:Text('Upload'),
    //                 ),
    //                 value: DisplayFilter.upload,
    //                 groupValue: _displayFilter,
    //                 onChanged: (value) { setState(() { _displayFilter = value; }); }
    //               ),
    //             ),                
    //           ],
    //         ),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: <Widget>[     
    //             Expanded(
    //               flex: 1,
    //               child: new LayoutBuilder(builder: (layoutContext, constraint) {
    //                 return _buildFileList(layoutContext, constraint, transferSvc);
    //               }),
    //             )
    //           ],
    //         ),
    //       ],
    //     )
    //   )
    // );
  }

  Widget _buildFileList(layoutContext, constraint, TransferService transferSvc) {
    
    var  filteredList = <FileTransfer>[];
    if (transferSvc.fileTransfers.isNotEmpty) {

      switch(_displayFilter) {
        case DisplayFilter.all: {
          filteredList = transferSvc.fileTransfers;
        }
        break;
        case DisplayFilter.download: {
          filteredList = transferSvc.fileTransfers.where(
            (fileTransfer) {
              return fileTransfer is DownloadFileTransfer;
            }
          ).toList();
        }
        break;
        case DisplayFilter.upload: {
          filteredList = transferSvc.fileTransfers.where(
            (fileTransfer) {
              return fileTransfer is UploadFileTransfer;
            }
          ).toList();
        }
        break;
      }
    }
    return ListView.separated(
        separatorBuilder: (context, i) {
          return Divider();
        },
        itemCount: filteredList.length,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          return _buildRow(filteredList[i], i, layoutContext, constraint);
        }
    );
  }

  Widget _buildRow(
      FileTransfer fileTransfer, int index, layoutContext, constraint) {
    // final bool alreadySaved = _saved.contains(pair);

    return ListTile(
      title: Text(
        '${fileTransfer.displayName}',
        style: _biggerFont,
      ),
      subtitle: LinearProgressIndicator(
        backgroundColor: Colors.white,
        value: fileTransfer.currentPercentage 
      ),
    );
    
  }

}


abstract class FileTransfer  {
  String id;
  int totalBytes;
  int _bytesTransferred;
  FileTransfer() {
    this.id = Uuid().v4().toString();
    this._bytesTransferred = 0;
  }

  String get localFilePath {}
  String get remoteFilePath {}
  String get displayName {}
  double get currentPercentage {}
}

class UploadFileTransfer extends FileTransfer {

}
class DownloadFileTransfer extends FileTransfer {
  siriusTypes.File remoteFile;
  String localFolderPath;
  TransferService transferSvc;
  DownloadFileTransfer(this.transferSvc, this.remoteFile, this.localFolderPath) : super();

  @override
  String get localFilePath {
    return '$localFolderPath/${remoteFile.name}';
  }

  @override
  double get currentPercentage {
    if (totalBytes == 0) {
      return 0;
    }
    return _bytesTransferred/remoteFile.size.toInt();
  }

  @override
  String get remoteFilePath {
    return '${remoteFile.path}';
  }

  @override
  String get displayName {
    return 'Downloading ${remoteFile.name}';
  }

  Future<void> run(SiriusClient siriusClient,  notifier ()) {
    final localFile = File(localFilePath);
    var publishProgress = (int bytesTransferred) {
      _bytesTransferred += bytesTransferred;
      transferSvc.bytesTransferred += bytesTransferred;
      notifier();
      // Notify listener
    };
    return downloadFile(siriusClient, localFile, remoteFile.path, publishProgress);
  }
}

class TransferService with ChangeNotifier{
  String currentTransferID;
  List<FileTransfer> fileTransfers = <FileTransfer>[];
  int bytesTransferred = 0;
  int _downloadRate;

  static String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }

  String get downloadRate {
    return formatBytes(_downloadRate, 2);
  }

  TransferService() : super() {
    const oneSec = const Duration(seconds:2);
    new Timer.periodic(
      oneSec, 
      (Timer t) {
        _downloadRate = (bytesTransferred/2).toInt();
        bytesTransferred = 0;
        notifyListeners();
      }
    ); 
  }
  


  String newFileDownload(SiriusClient siriusClient, siriusTypes.File remoteFile, String localFolderPath) {
    var fileDownload = new DownloadFileTransfer(this, remoteFile, localFolderPath);
    fileTransfers.add(fileDownload);
    fileDownload.run(siriusClient, notifyListeners).then(
      (onVal) {
        fileTransfers.removeWhere(
          (onVal) {
            if (onVal.id == fileDownload.id) {
              notifyListeners();
              return true;
            }
            return false;
          }
        );
        
      }
    );
    return fileDownload.id;
  }

  

  // TransferService(EventBus eventBus) {
  //   print('TransferScreenState');
    
  //   // eventBus.on<FileDownloadEvent>().listen(
  //   //   (event) {
  //   //     // print('Received FileDownloadEvent: $event');
  //   //     if (event.transferID != currentTransferID) {
  //   //       print('Wrong transfer ID, event ignored');
  //   //       return;
  //   //     }
  //   //     totalBytes += event.totalFileSize;
  //   //     notifyListeners();
  //   //   }
  //   // );
  //   // eventBus.on<FileDownloadProgressEvent>().listen(
  //   //   (event) {
  //   //     // print('Received FileDownloadProgressEvent: $event');
  //   //     if (event.transferID != currentTransferID) {
  //   //       print('Wrong transfer ID, event ignored');
  //   //     }
  //   //     bytesTransferred += event.bytesTransferred;
  //   //     notifyListeners();
  //   //   }
  //   // );
  // }

  // getPercentage get 

  // double get currentPercentage {
  //   if (totalBytes == 0) {
  //     return 0;
  //   }
  //   return bytesTransferred/totalBytes;
  // }

}
