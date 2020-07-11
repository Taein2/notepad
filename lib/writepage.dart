import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class note{

  String title;
  String contents;

  note(this.title, this.contents);
}


class writepage extends StatefulWidget {
  _write createState() => _write();

}
class _write extends State<writepage> {

  final maxLines = 15;

  var _todoController1 = TextEditingController();    //저장을 위한 문자열 조작 컨트롤러
  var _todoController2 = TextEditingController();
  void dispose(){
    _todoController1.dispose();    // 사용이 끝나면 해제
    _todoController2.dispose();    // 사용이 끝나면 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('작성'),
        ),
        body: new Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(20.0),
              child: new Column(
                children: <Widget>[
                  Text('제목'),
                  TextField(
                    controller: _todoController1,
                    decoration: InputDecoration(
                      border:OutlineInputBorder(),
                      hintText: "제목을 입력하세요",
                    ),
                    maxLength: 20,

                  ),
                  Text('내용'),
                  TextField(
                    controller: _todoController2,
                    maxLines: maxLines,
                    decoration: InputDecoration(
                      border:OutlineInputBorder(),
                      hintText: "내용을 입력하세요",
                    ),
                    maxLength: 100,
                  ),
                  RaisedButton(
                    child: Text('저장'),
                    onPressed:() => _addnote(note(_todoController1.text,_todoController2.text)),

                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _addnote(note note){
    Firestore.instance.collection('note').add({'title':note.title, 'contents':note.contents});

    _todoController1.text = '';
    _todoController2.text = '';
    Navigator.pop(context, '저장 완료');
  }

}

