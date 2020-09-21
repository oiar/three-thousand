import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:three_thousand/database/model/time_recording.dart';
import 'package:three_thousand/pages/recording/update_record.dart';
import 'package:three_thousand/record_presenter.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

class TimeLine extends StatelessWidget {
  List<Time> country;
  HomePresenter homePresenter;

  TimeLine(
    List<Time> this.country,
    HomePresenter this.homePresenter,
    {Key key}
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(ScreenUtil().setWidth(32)),
      child: Timeline.builder(
        position: TimelinePosition.Left,
        lineWidth: ScreenUtil().setWidth(1.0),
        itemCount: country == null ? 0 : country.length,
        itemBuilder: (BuildContext context, int index) {
          int times = country[index].counter;
          return TimelineModel(
            Container(
              margin: EdgeInsets.all(ScreenUtil().setWidth(32)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('The ' + '$times' + 'th time', style: TextStyle(fontSize: ScreenUtil().setWidth(34)),),
                  Text(country[index].recording, style: TextStyle(fontSize: ScreenUtil().setWidth(36)),),
                  new Row(
                    children: <Widget>[
                      new IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: const Color(0xFF6dfbfb),
                            size: ScreenUtil().setWidth(64)
                          ),
                          onPressed: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => UpdateRecord(updateRecord: country[index]),
                              )
                            );
                            homePresenter.updateScreen();
                          },
                        ),

                      new IconButton(
                        icon: const Icon(
                          Icons.delete_forever,
                          color: const Color(0xFF6dfbfb)),
                          iconSize: ScreenUtil().setWidth(64),
                          onPressed: () =>
                            homePresenter.delete(country[index]),
                      ),
                    ],
                  ),
                ],
              ),
            )
          );
        },
      )
    );
  }
}