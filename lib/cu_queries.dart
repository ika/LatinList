import 'dart:async';
import 'package:flutterapplatinlist/constants.dart';
import 'package:flutterapplatinlist/model.dart';
import 'package:sqflite/sqflite.dart';

import 'cu_helper.dart';

CustomDBHelper con = CustomDBHelper();

class CustomDBQueries {
  final String _dbTable = Constants.customTBName;

  Future<int> insertModel(CustomModel model) async {
    final db = await con.db;
    return await db.insert(_dbTable, model.toMap());
  }

  Future<int> updateModel(CustomModel model) async {
    final db = await con.db;
    return await db.update(_dbTable, model.toMap(),
        where: 'id=?', whereArgs: [model.id]);
  }

  Future<List<CustomModel>> getModelList() async {
    final db = await con.db;
    var res = await db.query(_dbTable, orderBy: 'id DESC');
    List<CustomModel> modelList =
        res.isNotEmpty ? res.map((e) => CustomModel.fromMap(e)).toList() : [];
    return modelList;
  }

  Future<int> deleteModel(int id) async {
    final db = await con.db;
    return await db.delete(_dbTable, where: 'id=?', whereArgs: [id]);
  }

  // Future<int> getCount() async {
  //   final db = await con.db;
  //   return Sqflite.firstIntValue(
  //       await db.rawQuery('SELECT COUNT(*) FROM $_dbTable'));
  // }
}
