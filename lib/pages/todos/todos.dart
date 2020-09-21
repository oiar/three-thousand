import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Todos extends StatefulWidget {
  Todos({Key key}) : super(key: key);

  _TodosState createState() => _TodosState();
}

class _TodosState extends State<Todos> {
  Widget getClapButton() {
    return new GestureDetector(
      child: new Container(
        height: ScreenUtil().setWidth(160),
        width: ScreenUtil().setWidth(160),
        decoration: new BoxDecoration(
          border: new Border.all(color: Color(0xFF6dfbfb), width: 1.0),
          borderRadius: new BorderRadius.circular(50.0),
          color: Colors.white,
          boxShadow: [
            new BoxShadow(color: Color(0xFF6dfbfb), blurRadius: 8.0)
          ]
        ),
        child: Center(child: Text('Start', style: TextStyle(color: Color(0xFF6dfbfb), fontSize: ScreenUtil().setWidth(44)),)),
      ),
      onTap: () {
        Navigator.pushNamed(context, '/add_todos');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text('Finished', style: TextStyle(color: Color(0xFF6dfbfb), fontSize: ScreenUtil().setWidth(72))),
      ),
      body: Container(
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: ScreenUtil().setWidth(200),
                      width: ScreenUtil().setWidth(200),
                      child: Stack(
                        alignment: Alignment(0.0, 0.0),
                        children: <Widget>[
                          Image.asset('lib/assets/images/star-teal.png'),
                          Text(
                            '0',
                            style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setWidth(72), fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Text(' time', style: TextStyle(color: Color(0xFF6dfbfb), fontSize: ScreenUtil().setWidth(72)),)
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Container(
                  height: ScreenUtil().setWidth(160),
                  width: ScreenUtil().setWidth(160),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Padding(padding: EdgeInsets.all(ScreenUtil().setWidth(60)), child: getClapButton()),
    );
  }
}
