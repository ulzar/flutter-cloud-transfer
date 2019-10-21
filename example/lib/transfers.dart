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

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'commons.dart';



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
