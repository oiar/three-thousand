import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Recording extends StatefulWidget {
  Recording({Key key}) : super(key: key);

  _RecordingState createState() => _RecordingState();
}

enum ScoreWidgetStatus {
  HIDDEN,
  BECOMING_VISIBLE,
  VISIBLE,
  BECOMING_INVISIBLE
}

class _RecordingState extends State<Recording> with TickerProviderStateMixin {
  int _counter;
  String _text;
  double _sparklesAngle = 0.0;
  ScoreWidgetStatus _scoreWidgetStatus = ScoreWidgetStatus.HIDDEN;
  final duration = new Duration(milliseconds: 400);
  final oneSecond = new Duration(seconds: 1);
  Random random;
  Timer holdTimer, scoreOutETA;
  AnimationController scoreInAnimationController, scoreOutAnimationController,
      scoreSizeAnimationController, sparklesAnimationController;
  Animation scoreOutPositionAnimation, sparklesAnimation;

  initState() {
    super.initState();
    _todos();
    _getCounter();
    random = new Random();
    scoreInAnimationController = new AnimationController(duration: new Duration(milliseconds: 300), vsync: this);
    scoreInAnimationController.addListener((){
      setState(() {}); // Calls render function
    });

    scoreOutAnimationController = new AnimationController(vsync: this, duration: duration);
    scoreOutPositionAnimation = new Tween(begin: 500.0, end: 550.0).animate(
      new CurvedAnimation(parent: scoreOutAnimationController, curve: Curves.easeOut)
    );
    scoreOutPositionAnimation.addListener((){
      setState(() {});
    });
    scoreOutAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scoreWidgetStatus = ScoreWidgetStatus.HIDDEN;
      }
    });

    scoreSizeAnimationController = new AnimationController(vsync: this, duration: new Duration(milliseconds: 300));
    scoreSizeAnimationController.addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        scoreSizeAnimationController.reverse();
      }
    });
    scoreSizeAnimationController.addListener((){
      setState(() {});
    });

    sparklesAnimationController = new AnimationController(vsync: this, duration: duration);
    sparklesAnimation = new CurvedAnimation(parent: sparklesAnimationController, curve: Curves.easeIn);
    sparklesAnimation.addListener((){
      setState(() { });
    });
  }

  _todos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String todo = prefs.getString('todo');
    setState(() {
      _text = todo;
    });
  }

  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt('counter') ?? 0) + 1;
    await prefs.setInt('counter', counter);
    setState((){
      _counter = counter;
    });
    Future.delayed(const Duration(seconds: 1), () => _addRecord());
  }

  _getCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = prefs.getInt('counter');
    setState(() {
      _counter = counter;
    });
  }

  void _addRecord() {
    Navigator.pushNamed(context, '/editing');
  }

  dispose() {
   super.dispose();
   scoreInAnimationController.dispose();
   scoreOutAnimationController.dispose();
  }

  void increment(Timer t) {
    scoreSizeAnimationController.forward(from: 0.0);
    sparklesAnimationController.forward(from: 0.0);
    setState(() {
      _sparklesAngle = random.nextDouble() * (2*pi);
    });
  }

  void onTapDown(TapDownDetails tap) {
    if (scoreOutETA != null) {
      scoreOutETA.cancel(); // We do not want the score to vanish!
    }
    if(_scoreWidgetStatus == ScoreWidgetStatus.BECOMING_INVISIBLE) {
      scoreOutAnimationController.stop(canceled: true);
      _scoreWidgetStatus = ScoreWidgetStatus.VISIBLE;
    }
    else if (_scoreWidgetStatus == ScoreWidgetStatus.HIDDEN ) {
      _scoreWidgetStatus = ScoreWidgetStatus.BECOMING_VISIBLE;
      scoreInAnimationController.forward(from: 0.0);
    }
    increment(null); // Take care of tap
    holdTimer = new Timer.periodic(duration, increment); // Takes care of hold
  }

  void onTapUp(TapUpDetails tap) {
    scoreOutETA = new Timer(oneSecond, () {
      scoreOutAnimationController.forward(from: 0.0);
      _scoreWidgetStatus = ScoreWidgetStatus.BECOMING_INVISIBLE;
    });
    holdTimer.cancel();
  }

  Widget getScoreButton() {
    var scorePosition = 0.0;
    var scoreOpacity = 0.0;
    var extraSize = 0.0;
    switch(_scoreWidgetStatus) {
      case ScoreWidgetStatus.HIDDEN:
        break;
      case ScoreWidgetStatus.BECOMING_VISIBLE :
      case ScoreWidgetStatus.VISIBLE:
        scorePosition = scoreInAnimationController.value * ScreenUtil().setWidth(1000);
        scoreOpacity = scoreInAnimationController.value;
        extraSize = scoreSizeAnimationController.value * 3;
        break;
      case ScoreWidgetStatus.BECOMING_INVISIBLE:
        scorePosition = scoreOutPositionAnimation.value;
        scoreOpacity = 1.0 - scoreOutAnimationController.value;
    }

    var stackChildren = <Widget>[
    ];

    var firstAngle = _sparklesAngle;
    var sparkleRadius = (sparklesAnimationController.value * ScreenUtil().setWidth(400)) ;
    var sparklesOpacity = (1 - sparklesAnimation.value);

    for(int i = 0;i < 7; ++i) {
      var currentAngle = (firstAngle + ((2*pi)/7)*(i));
      var sparklesWidget =
        new Positioned(child: new Transform.rotate(
          angle: currentAngle - pi/2,
          child: new Opacity(opacity: sparklesOpacity,
            child : new Image.asset("lib/assets/images/sun-9.png", width: ScreenUtil().setWidth(80), height: ScreenUtil().setWidth(80), color: Color(0xFF6dfbfb),))
        ),
        left: (sparkleRadius * cos(currentAngle)) + ScreenUtil().setWidth(40),
        top: (sparkleRadius * sin(currentAngle)) + ScreenUtil().setWidth(40) ,
      );
      stackChildren.add(sparklesWidget);
    }

    stackChildren.add(new Opacity(opacity: scoreOpacity, child: new Container(
      height: ScreenUtil().setWidth(140) + extraSize,
      width: ScreenUtil().setWidth(140)  + extraSize,
      decoration: new ShapeDecoration(
        shape: new CircleBorder(
          side: BorderSide.none
        ),
        color: Color(0xFF6dfbfb),
      ),
      child: new Center(
        child: Text(
          "+ 1",
          style: new TextStyle(color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: ScreenUtil().setWidth(48)),))
      )));

    var widget =  new Positioned(
      child: new Stack(
        alignment: FractionalOffset.center,
        overflow: Overflow.visible,
        children: stackChildren,
      ),
      bottom: scorePosition
    );
    return widget;
  }

  Widget getClapButton() {
    var extraSize = 0.0;
    if (_scoreWidgetStatus == ScoreWidgetStatus.VISIBLE || _scoreWidgetStatus == ScoreWidgetStatus.BECOMING_VISIBLE) {
      extraSize = scoreSizeAnimationController.value * 3;
    }
    return new GestureDetector(
      onTap: _incrementCounter,
      onTapUp: onTapUp,
      onTapDown: onTapDown,
      child: new Container(
        height: ScreenUtil().setWidth(160) + extraSize,
        width: ScreenUtil().setWidth(160) + extraSize,
        decoration: new BoxDecoration(
          border: new Border.all(color: Color(0xFF6dfbfb), width: ScreenUtil().setWidth(2.0)),
          borderRadius: new BorderRadius.circular(50.0),
          color: Colors.white,
          boxShadow: [
            new BoxShadow(color: Color(0xFF6dfbfb), blurRadius: 8.0)
          ]
        ),
        child: Icon(Icons.add, size: ScreenUtil().setWidth(80), color: Color(0xFF6dfbfb),),
      )
    );
  }

  Widget getTimesButton() {
    var extraSize = 0.0;
    if (_scoreWidgetStatus == ScoreWidgetStatus.VISIBLE || _scoreWidgetStatus == ScoreWidgetStatus.BECOMING_VISIBLE) {
      extraSize = scoreSizeAnimationController.value * 3;
    }
    return Container(
      height: ScreenUtil().setWidth(200) + extraSize,
      width: ScreenUtil().setWidth(200) + extraSize,
      child: Stack(
        alignment: Alignment(0.0, 0.0),
        children: <Widget>[
          Image.asset('lib/assets/images/star-teal.png'),
          Text(
            _counter == null ? '0' : '$_counter',
            style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setWidth(72), fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Finished', style: TextStyle(color: Color(0xFF6dfbfb), fontSize: ScreenUtil().setWidth(72))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.all(ScreenUtil().setWidth(32)),
            child: GestureDetector(
              child: Text('more', style: TextStyle(color: Color(0xFF6dfbfb), fontSize: ScreenUtil().setWidth(48))),
              onTap: () {
                Navigator.pushNamed(context, '/history');
              }
            )
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setWidth(100)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '$_text',
                  style: TextStyle(color: Colors.black87, fontSize: ScreenUtil().setWidth(48)),
                ),
                Container(
                  child: IconButton(
                    icon: Icon(Icons.edit, color: Color(0xFF6dfbfb), size: ScreenUtil().setWidth(64),),
                    onPressed: () => Navigator.pushNamed(context, '/update_todos'),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setWidth(200)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                getTimesButton(),
                Text(
                  ' times',
                  style: TextStyle(color: Colors.black87, fontSize: ScreenUtil().setWidth(72)),
                )
              ],
            )
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(200), left: ScreenUtil().setWidth(40)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: FractionalOffset.center,
              overflow: Overflow.visible,
              children: <Widget>[
                getScoreButton(),
                getClapButton()
              ],
            ),
          ],
        )
      ),
    );
  }
}