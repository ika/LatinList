import 'dart:async';
import 'package:flutterapplatinlist/constants.dart';
import 'package:flutterapplatinlist/db_model.dart';
import 'package:sqflite/sqflite.dart';

import 'db_helper.dart';

DBHelper con = DBHelper();

class DBQueries {
  final String _dbTable = Constants.listTBName;

  Future<int> insertModel(Model model) async {
    final db = await con.db;
    return await db.insert(_dbTable, model.toMap());
  }

  Future<int> updateModel(Model model) async {
    final db = await con.db;
    return await db.update(_dbTable, model.toMap(),
        where: 'id=?', whereArgs: [model.id]);
  }

  Future<List<Model>> getModelList() async {
    final db = await con.db;
    var res = await db.query(_dbTable, orderBy: 'id DESC');
    List<Model> modelList =
        res.isNotEmpty ? res.map((e) => Model.fromMap(e)).toList() : [];
    return modelList;
  }

  Future<int> deleteModel(int id) async {
    final db = await con.db;
    return await db.delete(_dbTable, where: 'id=?', whereArgs: [id]);
  }

  Future<int> getCount() async {
    final db = await con.db;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $_dbTable'));
  }
}
