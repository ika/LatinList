import 'dart:async';

import 'package:flutterapplatinlist/blocs/provider.dart';
import 'package:flutterapplatinlist/database/dbhelper.dart';
import 'package:flutterapplatinlist/models/model.dart';

class DetailBloc implements BlocBase {
  // Update
  final _updateController = StreamController<Model>.broadcast();
  StreamSink<Model> get updateSink => _updateController.sink;

  // delete
  final _deleteController = StreamController<int>.broadcast();
  StreamSink<int> get deleteSink => _deleteController.sink;

  // Add
  final _addController = StreamController<Model>.broadcast();
  StreamSink<Model> get addSink => _addController.sink;

  DetailBloc() {
    _updateController.stream.listen(_handleUpdate);
    _deleteController.stream.listen(_handelDelete);
    _addController.stream.listen(_handleAdd);
  }

  @override
  void dispose() {
    _updateController.close();
    _deleteController.close();
    _addController.close();
  }
}

void _handleUpdate(Model model) async {
  await DBProvider.db.updateModel(model);
}

void _handelDelete(int id) async {
  await DBProvider.db.deleteModel(id);
}

void _handleAdd(Model model) async {
  await DBProvider.db.insertModel(model);
}
