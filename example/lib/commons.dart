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
import 'package:event_bus/event_bus.dart';
import 'package:grpc/grpc.dart';
import 'package:path/path.dart' as path;
import 'src/generated/sirius/services/service.pbgrpc.dart' as siriusSvc;

EventBus globalEventBus = new EventBus();

const atheraJWT = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6Ik9UUkdPVGczTXpCRFJEWXpSVE00TVVNd09USkJNRGMwT1RGRE5VWXdSRVl4TWtORk56YzJOUSJ9.eyJodHRwczovL21ldGFkYXRhLmVsYXJhLmlvL2luZm8iOnsiYXV0aElkIjoiYXV0aDB8NWFlMDczNGU3MzY0ZWQzYzI5ZWExYmY0IiwiZWxhcmFVc2VySWQiOiI2ZjIwNmRkYy0yMzdjLTRjNTUtYjMyNC0yZDI2NmVjOTgwNDkiLCJhdXRoMF9pZCI6ImF1dGgwfDVhZTA3MzRlNzM2NGVkM2MyOWVhMWJmNCIsImVsYXJhX3VzZXJfaWQiOiI2ZjIwNmRkYy0yMzdjLTRjNTUtYjMyNC0yZDI2NmVjOTgwNDkifSwiaXNzIjoiaHR0cHM6Ly9pZC5hdGhlcmEuaW8vIiwic3ViIjoiYXV0aDB8NWFlMDczNGU3MzY0ZWQzYzI5ZWExYmY0IiwiYXVkIjoiaHR0cHM6Ly9wdWJsaWMuYXRoZXJhLmlvIiwiaWF0IjoxNTcxOTA4MDc0LCJleHAiOjE1NzE5OTQ0NzQsImF6cCI6Ik41Qng0eDZUb0tDQk01Q0hBVjlPNWVOYjdpR01uczhUIiwic2NvcGUiOiJvZmZsaW5lX2FjY2VzcyJ9.Lcud5sSldMYcgMo0S51yVbGanvZQWYui9IkrHCu--JhQ4etM9TqsEWr4UQgHB3d84wdSYM9tqNq4lHqD4R_LArNIyz0BO-lkfBOao4pujuAzgZcNH_EHHNaRYw2L-FV_iXLctSSxhj_TAhWHJGmWyO0G6ugLTYWxiO4RPFNAuhHc-YH2CuPptJmGy9u2Fr_iBwc0WMZmMKnJ8F3-9WkPWegrnfe_X7Pv5BGnJfkAblIfEn_hJT44Nfz92C0PH3ieIZPEaqi46cpzvnh_cQtaArT_4JtvUwcnDFFa03R1qRYoNWNRDFLhxVUKyUpgvibetdm_IxdAFI3VEwfYtBNrtw';


Map<String, String> metadata = {
      'authorization': 'bearer: $atheraJWT',
      'active-group': 'ee2219fb-d877-4475-8c03-408feabdabb3'
    };

// [('authorization', "bearer: {}".format(self.token)),
//                     ('active-group', group_id)]

ResponseStream<siriusSvc.FilesListResponse> listRemoteFiles(siriusSvc.SiriusClient siriusClient, String remoteFolderPath) {
    final request = siriusSvc.FilesListRequest();
    request..path = remoteFolderPath;
    request..mountId = '44e39b2f-ecb7-44d5-b9ea-c6ff98e84b8d';

    return siriusClient.filesList(request, options: CallOptions(metadata: metadata));
}

Future<void> downloadFile(siriusSvc.SiriusClient siriusClient, File localFile, String remoteFilePath, publishProgress (int byteTransferred)) async {
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
  bool isFolder;
  String parentFolderPath;
  String filePath;
  String name;
  CustomFile(
    bool paramIsFolder, String paramFilePath, String paramParentFolderPath
  ) {
    isFolder = paramIsFolder;
    filePath = paramFilePath;
    name = path.basename(paramFilePath);
    parentFolderPath = paramParentFolderPath;
  }
}

class InitTransferEvent {
  String remoteFolderPath;
  String localFolderPath;
  bool isUpload = false;

  InitTransferEvent(this.remoteFolderPath, this.localFolderPath, this.isUpload);
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
