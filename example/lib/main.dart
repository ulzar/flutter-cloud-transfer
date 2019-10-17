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

import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:english_words/english_words.dart';

void main() {
  // See https://github.com/flutter/flutter/wiki/Desktop-shells#target-platform-override
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

  runApp(new MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      // theme: ThemeData(
      //   primaryColor: Colors.amber,
      // ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Row(
        children: <Widget>[
          Expanded(
              child: LocalExplorer(),
          ),
          Container(
              width: 40,
              color: Colors.grey
          ),
          Expanded(
              child: RemoteExplorer()
          ),
        ]
    );
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
  final List<WordPair> _suggestions = <WordPair>[];
  // final Set<WordPair> _saved = Set<WordPair>();   // Add this line.
  final TextStyle _biggerFont = TextStyle(fontSize: 18.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Remote Folder Explorer'),
        // actions: <Widget>[
        //   IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        // ],
      ),
      body: new LayoutBuilder(builder: (layoutContext, constraint) {
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemBuilder: /*1*/ (context, i) {
            
            if (i.isOdd) return Divider(); /*2*/

            final index = i ~/ 2; /*3*/
            if (index >= _suggestions.length) {
              _suggestions.addAll(generateWordPairs().take(10)); /*4*/
            }
            return _buildRow(_suggestions[index], i, layoutContext, constraint);
          }
        );
      }),
    );
  }

  Widget _buildRow(WordPair pair, int index, layoutContext, constraint) {
    // final bool alreadySaved = _saved.contains(pair);
    var listTileWord = ListTile(
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
        // trailing: Icon(   // Add the lines from here... 
        //   alreadySaved ? Icons.favorite : Icons.favorite_border,
        //   color: alreadySaved ? Colors.red : null,
        // ),
        // onTap: () {
        //   setState(() {
        //     if(alreadySaved) {
        //       _saved.remove(pair);
        //     } else {
        //       _saved.add(pair);
        //     }
        //   });
        // },
      );
    return LongPressDraggable(
      key: new ObjectKey(index),
      data: pair.asPascalCase,
      child: new DragTarget<String>(
        builder: (BuildContext context, List<String> data, List<dynamic> rejects) {
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
          Scaffold.of(layoutContext).showSnackBar(new SnackBar (
            content: new Text(pair.asPascalCase + " Received folder " + data),
          ));
        },
      ),
      onDragStarted: () {
        Scaffold.of(layoutContext).showSnackBar(new SnackBar (
          content: new Text("Drag the row onto another row to change places"),
        ));
      },
      feedback:  new SizedBox(
        width: constraint.maxWidth,
        child: new Card (
          child: new Column(
            children: <Widget>[
              listTileWord
            ],
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
  @override
  LocalExplorerState createState() => LocalExplorerState();
}

class LocalExplorerState extends State<LocalExplorer> {
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _saved = Set<WordPair>();   // Add this line.
  final TextStyle _biggerFont = TextStyle(fontSize: 18.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Local Folder Explorer'),
        // actions: <Widget>[
        //   IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        // ],
      ),
      body: new LayoutBuilder(builder: (layoutContext, constraint) {
        return _buildSuggestions(layoutContext, constraint);
      }),
    );
  }

  Widget _buildSuggestions(layoutContext, constraint) {
    return ListView.builder(
      itemCount: 15,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: /*1*/ (context, i) {
        
        if (i.isOdd) return Divider(); /*2*/

        final index = i ~/ 2; /*3*/
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10)); /*4*/
        }
        return _buildRow(_suggestions[index], i, layoutContext, constraint);
    });
  }

  Widget _buildRow(WordPair pair, int index, layoutContext, constraint) {
    final bool alreadySaved = _saved.contains(pair);
    var listTileWord = ListTile(
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
        trailing: Icon(   // Add the lines from here... 
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
        onTap: () {
          setState(() {
            if(alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        },
      );
    return LongPressDraggable(
      key: new ObjectKey(index),
      data: pair.asPascalCase,
      child: new DragTarget<String>(
        builder: (BuildContext context, List<String> data, List<dynamic> rejects) {
          return new Card(
            child: new Column(
              children: <Widget>[
                listTileWord,
              ],
            ),
          );
        }
      ),
      onDragStarted: () {
        Scaffold.of(layoutContext).showSnackBar(new SnackBar (
          content: new Text("Drag the row onto another row to change places"),
        ));
      },
      feedback:  new SizedBox(
        width: constraint.maxWidth,
        child: new Card (
          child: new Column(
            children: <Widget>[
              listTileWord
            ],
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