import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_thousand/database/database_helper.dart';

class UpdateTodos extends StatefulWidget {
  UpdateTodos(
    {Key key}
  ) : super(key: key);

  _UpdateTodosState createState() => _UpdateTodosState();
}

class _UpdateTodosState extends State<UpdateTodos> {
final _todosController = new TextEditingController();
  initState() {
    super.initState();
    _gettodos();
  }

  _gettodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String todo = prefs.getString('todo');
    setState(() {
      _todosController.text = todo;
    });
  }

  _saveTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('todo', _todosController.text);
  }

  Future _removeCounter() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('counter');
  }

  Future _deleteAllRecord() async {
    var db = new DatabaseHelper();
    await db.deleteAll();
  }

  Future _issaveDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14.0))),
          title: Text('Are you sure to give up all the additions?', style: TextStyle(fontSize: ScreenUtil().setWidth(32)),),
          children: <Widget>[
            Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: FlatButton(
                    child: Text('No', style: TextStyle(fontSize: ScreenUtil().setWidth(32)),),
                    onPressed: () {
                      _saveTodos();
                      Navigator.pushNamed(context, '/recording');
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FlatButton(
                    child: Text('Yes', style: TextStyle(color: Color(0xFF6dfbfb), fontSize: ScreenUtil().setWidth(32)),),
                    onPressed: () {
                      _deleteAllRecord();
                      _removeCounter();
                      _saveTodos();
                      Navigator.pushNamed(context, '/recording');
                    },
                  ),
                )
              ],
            )
          ],
        );
      }
    );
    setState(() {});
  }

  Widget getSaveButton() {
    return new GestureDetector(
      child: new Container(
        height: 80.0,
        width: 80.0,
        decoration: new BoxDecoration(
          border: new Border.all(color: Color(0xFF6dfbfb), width: 1.0),
          borderRadius: new BorderRadius.circular(50.0),
          color: Colors.white,
          boxShadow: [
            new BoxShadow(color: Color(0xFF6dfbfb), blurRadius: 8.0)
          ]
        ),
        child: Center(child: Text('Save', style: TextStyle(color: Color(0xFF6dfbfb), fontSize: ScreenUtil().setWidth(44)),)),
      ),
      onTap: () {
        _issaveDialog();
        _saveTodos();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        focusColor: Color(0xFF6dfbfb),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Update Activity', style: TextStyle(color: Color(0xFF6dfbfb), fontSize: ScreenUtil().setWidth(64))),
          iconTheme: IconThemeData(color: Color(0xFF6dfbfb)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          margin: EdgeInsets.all(ScreenUtil().setWidth(40)),
          child: TextField(
            controller: _todosController,
            cursorColor: Color(0xFF6dfbfb),
            maxLines: 5,
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
        floatingActionButton: Padding(padding: EdgeInsets.all(ScreenUtil().setWidth(60)), child: getSaveButton()),
      )
    );
  }
}