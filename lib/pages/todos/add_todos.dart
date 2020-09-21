import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddTodos extends StatefulWidget {
  AddTodos({Key key}) : super(key: key);
  _AddTodosState createState() => _AddTodosState();
}

class _AddTodosState extends State<AddTodos> {
  final _todosController = new TextEditingController();

  _todos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String todo = prefs.getString('todo') ?? _todosController.text;
    await prefs.setString('todo', todo);
    setState(() {
      _todosController.text = todo;
    });
  }

  Widget getSaveButton() {
    return new GestureDetector(
      child: new Container(
        height: ScreenUtil().setWidth(160),
        width: ScreenUtil().setWidth(160),
        decoration: new BoxDecoration(
          border: new Border.all(color: Color(0xFF6dfbfb), width: ScreenUtil().setWidth(2.0)),
          borderRadius: new BorderRadius.circular(50.0),
          color: Colors.white,
          boxShadow: [
            new BoxShadow(color: Color(0xFF6dfbfb), blurRadius: 8.0)
          ]
        ),
        child: Center(child: Text('Save', style: TextStyle(color: Color(0xFF6dfbfb), fontSize: ScreenUtil().setWidth(44)),)),
      ),
      onTap: () {
        _todos();
        Navigator.pushNamed(context, '/recording');
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
          title: Text('Activity', style: TextStyle(color: Color(0xFF6dfbfb), fontSize: ScreenUtil().setWidth(72))),
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
                borderSide: BorderSide(color: Color(0xFF6dfbfb), width: ScreenUtil().setWidth(1.0)),
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