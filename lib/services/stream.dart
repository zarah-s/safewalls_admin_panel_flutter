import 'dart:async';

import 'package:flutter_demo/models/data_model.dart';

class StreamSocket {
  final _socketResponse = StreamController<DataModel>();

  void Function(DataModel) get addResponse => _socketResponse.sink.add;

  Stream<DataModel> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}
