class Time {
  int id;
  int _counter;
  String _recording;
  String _activity;

  Time(this._counter, this._recording, this._activity);

  Time.map(dynamic obj) {
    this._activity = obj["activity"];
    this._recording = obj["recording"];
    this._counter = obj["counter"];
  }

  String get activity => _activity;
  String get recording => _recording;
  int get counter => _counter;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["activity"] = _activity;
    map["recording"] = _recording;
    map["counter"] = _counter;
    return map;
  }

  void setTimeId(int id) {
    this.id = id;
  }
}