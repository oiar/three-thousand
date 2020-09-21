import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:three_thousand/database/database_helper.dart';
import 'package:three_thousand/database/model/time_recording.dart';
import 'package:three_thousand/record_presenter.dart';

class UpdateRecord extends StatefulWidget {
  final Time updateRecord;
  UpdateRecord({Key key, this.updateRecord}) : super(key: key);

  _UpdateRecordState createState() => _UpdateRecordState();
}

class _UpdateRecordState extends State<UpdateRecord> implements HomeContract{
  HomePresenter homePresenter;
  final _todosController = TextEditingController();
  final _recordingController = TextEditingController();
  int _counters;
  Time record;

  void initState() {
    super.initState();
    homePresenter = new HomePresenter(this);
    setState(() {
      this._recordingController.text = widget.updateRecord.recording;
      this._counters = widget.updateRecord.counter;
      this._todosController.text = widget.updateRecord.activity;
    });
  }

  Future updateRecord() async {
    var db = new DatabaseHelper();
    var record = Time(_counters, _recordingController.text, _todosController.text);
    record.setTimeId(widget.updateRecord.id);
    print(widget.updateRecord.id);
    await db.update(record);
  }

  displayRecord() {
    homePresenter.updateScreen();
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
        updateRecord();
        displayRecord();
        Navigator.pushNamed(context, '/history');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Color(0xFF6dfbfb), size: ScreenUtil().setWidth(32)),
        title: Text('Update Recording', style: TextStyle(color: Color(0xFF6dfbfb), fontSize: ScreenUtil().setWidth(64)))
      ),
      body: Container(
        margin: EdgeInsets.all(ScreenUtil().setWidth(40)),
        child: TextField(
          controller: _recordingController,
          cursorColor: Color(0xFF6dfbfb),
          // maxLines: 5,
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
    );
  }

  @override
  void screenUpdate() {
  }
}