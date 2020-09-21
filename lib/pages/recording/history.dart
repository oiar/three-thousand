import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:three_thousand/database/model/time_recording.dart';
import 'package:three_thousand/pages/recording/time_line.dart';
import 'package:three_thousand/record_presenter.dart';

class History extends StatefulWidget {
  History({Key key}) : super(key: key);

  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> implements HomeContract {
  HomePresenter homePresenter;
  
  @override
  void initState() {
    super.initState();
    homePresenter = new HomePresenter(this);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.only(left: ScreenUtil().setWidth(32)),
          child: IconButton(
            icon: Icon(Icons.navigate_before, color: Color(0xFF6dfbfb), size: ScreenUtil().setWidth(64),),
            onPressed: () => Navigator.pushNamed(context, '/recording'),
          )
        ),
        title: Text('My Recordings', style: TextStyle(color: Color(0xFF6dfbfb), fontSize: ScreenUtil().setWidth(64))),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Theme(
        data: ThemeData(
          iconTheme: IconThemeData(color: Color(0xFF6dfbfb)),
          primaryColor: Color(0xFF6dfbfb)
        ),
        child: FutureBuilder<List<Time>>(
          future: homePresenter.getRecord(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            var data = snapshot.data;
            return snapshot.hasData
                ? new TimeLine(data,homePresenter)
                : new Center(child: new CircularProgressIndicator());
          },
        )
      ),
    );
  }

  @override
  void screenUpdate() {
    setState(() {});
  }
}