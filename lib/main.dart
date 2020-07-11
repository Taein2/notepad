import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notepad/writepage.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '메모장',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: '메모장'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("메모장")),
      body: Column(children: <Widget>[
        Container(
          height: 500,
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection("note").orderBy('title').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) return Text("Error: ${snapshot.error}");
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Text("Loading...");
                default:
                  return ListView(
                    children: snapshot.data.documents.map((DocumentSnapshot document) {

                      return Card(
                        elevation: 2,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    document["title"],
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.delete_forever),
                                      onPressed: () => _delete(document),
                                    ),
                                ],
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  document["contents"],
                                  style: TextStyle(color: Colors.black54),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
              }
            },
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => writepage()));
        },
        child: Icon(Icons.border_color),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );


  }
  void _delete(DocumentSnapshot doc){
    Firestore.instance.collection('note').document(doc.documentID).delete();


  }
}
