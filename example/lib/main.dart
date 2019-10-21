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
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'localFolder.dart';
import 'remoteFolder.dart';
import 'transfers.dart';

void main() {
  // See https://github.com/flutter/flutter/wiki/Desktop-shells#target-platform-override
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

  runApp(new MyApp());
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


class MyHomePage extends StatefulWidget {
  // MyHomePage({Key key, this.title, this.eventBus}) : super(key: key);
  final String title;
  MyHomePage({Key key, this.title, this.eventBus}) : super(key: key); 

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
