import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_thousand/pages/recording/add_record.dart';
import 'package:three_thousand/pages/recording/history.dart';
import 'package:three_thousand/pages/recording/record_times.dart';
import 'package:three_thousand/pages/todos/add_todos.dart';
import 'package:three_thousand/pages/todos/update_todos.dart';

import 'pages/todos/todos.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Activity'),
      routes: {
        '/todos': (BuildContext context) => Todos(),
        '/add_todos': (BuildContext contest) => AddTodos(),
        '/recording': (BuildContext context) => Recording(),
        '/editing': (BuildContext context) => Editing(),
        '/history': (BuildContext context) => History(),
        '/update_todos': (BuildContext context) => UpdateTodos()
      },
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
  int _counter;
  initState() {
    super.initState();
    _incrementCounter();
  }

  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = prefs.getInt('counter') ?? 0;
    setState((){
      _counter = counter;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 828, height: 1792, allowFontScaling: true)..init(context);
    return Scaffold(
      body: _counter == 0 ? Todos() : Recording(),
    );
  }
}
