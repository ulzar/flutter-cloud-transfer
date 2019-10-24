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
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:path/path.dart' as path;
import 'commons.dart';
import 'src/generated/sirius/services/service.pbgrpc.dart' as siriusSvc;
import 'src/generated/sirius/types/file.pbenum.dart' as siriusTypes;



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
    );
  }

  Future<List<FileSystemEntity>> listFiles(String remotePath) async {
    print('remotePath=$remotePath');
    _currentDirectoryPath = remotePath;
    // print('List path : $remotePath');
    final List<CustomFile> tmp_suggestions = <CustomFile>[];
    
    await for (var fileListResponse in listRemoteFiles(siriusClient, remotePath)) {
      final file = fileListResponse.file;
      if (file.type == siriusTypes.File_Type.DIRECTORY) {
        var newFile = new CustomFile(
          true, file.path, remotePath
        );
        tmp_suggestions.add(newFile);
      }
    }

    print('ListFiles $remotePath: $tmp_suggestions');

    setState(() {
      _suggestions = tmp_suggestions;
    });
  }

  Widget _buildRow(
      CustomFile remoteFolder, int index, layoutContext, constraint) {
    var listTileWord = ListTile(
      title: Text(
        remoteFolder.name,
        style: _biggerFont,
      ),
      onTap: () {
        setState(() {
          listFiles(remoteFolder.filePath);
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
                new Text(remoteFolder.filePath + " Received folder " + data.path),
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
