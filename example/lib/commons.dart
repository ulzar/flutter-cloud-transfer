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
import 'package:event_bus/event_bus.dart';
import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';
import 'package:path/path.dart' as path;
import 'src/generated/sirius/services/service.pbgrpc.dart' as siriusSvc;

EventBus globalEventBus = new EventBus();

const atheraJWT = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6Ik9UUkdPVGczTXpCRFJEWXpSVE00TVVNd09USkJNRGMwT1RGRE5VWXdSRVl4TWtORk56YzJOUSJ9.eyJodHRwczovL21ldGFkYXRhLmVsYXJhLmlvL2luZm8iOnsiYXV0aElkIjoiYXV0aDB8NWFlMDczNGU3MzY0ZWQzYzI5ZWExYmY0IiwiZWxhcmFVc2VySWQiOiI2ZjIwNmRkYy0yMzdjLTRjNTUtYjMyNC0yZDI2NmVjOTgwNDkiLCJhdXRoMF9pZCI6ImF1dGgwfDVhZTA3MzRlNzM2NGVkM2MyOWVhMWJmNCIsImVsYXJhX3VzZXJfaWQiOiI2ZjIwNmRkYy0yMzdjLTRjNTUtYjMyNC0yZDI2NmVjOTgwNDkifSwiaXNzIjoiaHR0cHM6Ly9pZC5hdGhlcmEuaW8vIiwic3ViIjoiYXV0aDB8NWFlMDczNGU3MzY0ZWQzYzI5ZWExYmY0IiwiYXVkIjoiaHR0cHM6Ly9wdWJsaWMuYXRoZXJhLmlvIiwiaWF0IjoxNTcyMjY4NjYxLCJleHAiOjE1NzIzNTUwNjEsImF6cCI6Ik41Qng0eDZUb0tDQk01Q0hBVjlPNWVOYjdpR01uczhUIiwic2NvcGUiOiJvZmZsaW5lX2FjY2VzcyJ9.o0HbKxSI3Y03FmBJUwBku9Z5rnZqkM6_oS0pYABGi1YmcyLaiaZpi4QE1o7xYXMljKMTFpY0VuiPzWeMhctDzr7ABu0bVuU8rfbXHKwnM7NNft5fAm78JxF3uU1BYvXLR0oIaqGCv9hvlg0jj-2_uotijfUXaBuTr-FwWI43fhe4bk4IVntvjN9MhDMeKc10fifNPxw0HXDtEUCwwToKvf8zJCsmLqz3yZuM8jRCKDmTDPdLBDTQjCRIsdTNFHbJOWmp-lU6YdqRE_4smwhPaPytLgmkZZOE54NddCKMyZp1DKOvP_BxGlguAr8d5pekwvxWLPtSk-mwClrDRsO5pA';



Map<String, String> metadata = {
      'authorization': 'bearer: $atheraJWT',
      'active-group': 'ee2219fb-d877-4475-8c03-408feabdabb3'
    };


ResponseStream<siriusSvc.FilesListResponse> listRemoteFiles(siriusSvc.SiriusClient siriusClient, String remoteFolderPath) {
    final request = siriusSvc.FilesListRequest();
    request..path = remoteFolderPath;
    request..mountId = '44e39b2f-ecb7-44d5-b9ea-c6ff98e84b8d';

    return siriusClient.filesList(request, options: CallOptions(metadata: metadata));
}

const KB = 1024;
const readChunk = 300*KB;

Future<void> uploadFile(siriusSvc.SiriusClient siriusClient, File localFile, int localFileSize, String remoteFilePath, publishProgress (int byteTransferred)) async {


    final streamController = new StreamController<siriusSvc.FileUploadRequest>();
    final uploadFileMetadata = {
      'authorization': 'bearer: $atheraJWT',
      'active-group': 'ee2219fb-d877-4475-8c03-408feabdabb3',
      'mount-id': '44e39b2f-ecb7-44d5-b9ea-c6ff98e84b8d',
      'path': remoteFilePath
    };
    var totalBytesRead = 0;

    final randomAccessFile = await localFile.open(mode: FileMode.read);
    var readBuffer = new List<int>(); // Buffer of 500 kB

    final request = siriusSvc.FileUploadRequest();
    readBuffer = await randomAccessFile.read(readChunk);
    request..chunkSize = Int64(readBuffer.length);
    request..bytes = readBuffer;
    streamController.add(request);

    await for (siriusSvc.FileUploadResponse _ in siriusClient.fileUploadV2(streamController.stream, options: CallOptions(metadata: uploadFileMetadata))) {
        // print('Sent new request with ${readBuffer.length} bytes');
        totalBytesRead += readBuffer.length;

        if (readBuffer.length < readChunk) {
          print('Done with the upload - (${totalBytesRead}/${localFileSize})');
          await streamController.close();
          return;
        }

        readBuffer = await randomAccessFile.read(readChunk);
        if (readBuffer.isEmpty) {
          print('Done with the upload - Nothing else to read');
          await streamController.close();
          return;
        }
        publishProgress(readBuffer.length);
        request..chunkSize = Int64(readBuffer.length);
        request..bytes = readBuffer;
        streamController.add(request);
    }
    await streamController.close();
    return;
}

Future<void> downloadFile(siriusSvc.SiriusClient siriusClient, File localFile, String remoteFilePath, publishProgress (int byteTransferred)) async {
    final request = siriusSvc.FileDownloadRequest();
    request..path = remoteFilePath;
    request..mountId = '44e39b2f-ecb7-44d5-b9ea-c6ff98e84b8d';
    int totalBytesWritten = 0;

    var streamController = new StreamController<siriusSvc.FileDownloadRequest>();
    streamController.add(request);

    await for (var fileDownloadResponse in siriusClient.fileDownload(streamController.stream, options: CallOptions(metadata: metadata))) {
        localFile.writeAsBytes(fileDownloadResponse.bytes);
        publishProgress(fileDownloadResponse.bytes.length);
        totalBytesWritten += fileDownloadResponse.bytes.length;
        streamController.add(request); // ACK
    }
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

