
import 'package:three_thousand/database/database_helper.dart';
import 'package:three_thousand/database/model/time_recording.dart';

abstract class HomeContract {
  void screenUpdate();
}

class HomePresenter {
  HomeContract _view;
  var db = new DatabaseHelper();
  HomePresenter(this._view);

  delete(Time record) {
    var db = new DatabaseHelper();
    db.deleteTimes(record);
    updateScreen();
  }

  Future<List<Time>> getRecord() {
    return db.getRecording();
  }

  updateScreen() {
    _view.screenUpdate();
  }
}
