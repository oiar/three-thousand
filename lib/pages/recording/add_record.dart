import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_thousand/database/database_helper.dart';
import 'package:three_thousand/database/model/time_recording.dart';
import 'package:three_thousand/record_presenter.dart';

class Editing extends StatefulWidget {
  Editing(
    {Key key}
  ) : super(key: key);

  _EditingState createState() => _EditingState();
}

class _EditingState extends State<Editing> implements HomeContract {
  final _todosController = TextEditingController();
  final _recordingController = TextEditingController();
  int _counters;
  Time record;
  int textIndex;

  void initState() {
    super.initState();
    _incrementCounter();
    _todos();
  }

  _todos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String todo = prefs.getString('todo');
    setState(() {
      _todosController.text = todo;
    });
  }

  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = prefs.getInt('counter');
    setState((){
      _counters = counter;
    });
  }

  Future addRecord() async {
    var db = new DatabaseHelper();
    var record = Time(_counters, _recordingController.text, _todosController.text);
    await db.saveRecording(record);
  }

  Widget getSaveButton() {
    return new GestureDetector(
      child: new Container(
        height: ScreenUtil().setWidth(160.0),
        width: ScreenUtil().setWidth(160),
        decoration: new BoxDecoration(
          border: new Border.all(color: Color(0xFF6dfbfb), width: 1.0),
          borderRadius: new BorderRadius.circular(50.0),
          color: Colors.white,
          boxShadow: [
            new BoxShadow(color: Color(0xFF6dfbfb), blurRadius: 8.0)
          ]
        ),
        child: Center(child: Text('Save', style: TextStyle(color: Color(0xFF6dfbfb), fontSize: ScreenUtil().setWidth(44.0)),)),
      ),
      onTap: () {
        addRecord();
        Navigator.pushNamed(context, '/history');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if(record != null) {
      this.record = record;
      _recordingController.text = record.recording;
      _todosController.text = record.activity;
      _counters = record.counter;
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Color(0xFF6dfbfb)),
        title: Text('Add Recording', style: TextStyle(color: Color(0xFF6dfbfb), fontSize: ScreenUtil().setWidth(64)))
      ),
      body: Container(
        height: ScreenUtil().setWidth(500),
        margin: EdgeInsets.all(ScreenUtil().setWidth(40.0)),
        child: TextField(
          controller: _recordingController,
          cursorColor: Color(0xFF6dfbfb),
          maxLines: 5,
          // maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            border: InputBorder.none,
            filled: true,
            fillColor: Color(0xFFedffff),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF6dfbfb), width: 0.5),
              borderRadius: BorderRadius.all(Radius.circular(14.0))
            )
          ),
        ),
      ),
      floatingActionButton: Padding(padding: EdgeInsets.all(ScreenUtil().setWidth(60.0)), child: getSaveButton()),
    );
  }

  @override
  void screenUpdate() {
  }
}