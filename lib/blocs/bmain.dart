import 'dart:async';

import 'package:flutterapplatinlist/blocs/provider.dart';
import 'package:flutterapplatinlist/database/dbhelper.dart';
import 'package:flutterapplatinlist/models/model.dart';

class MainBloc implements BlocBase {

  // modelList
  final _mainController = StreamController<List<Model>>.broadcast();
  // input
  StreamSink<List<Model>> get _inputSink => _mainController.sink;
  // output
  Stream<List<Model>> get ouputStream => _mainController.stream;

  MainBloc() {
    getModelList();
  }

  @override
  void dispose() {
    _mainController.close();
  }

  void getModelList() async {
    List<Model> modelList = await DBProvider.db.getModelList();
    // add to stream
    _inputSink.add(modelList);
  }

}