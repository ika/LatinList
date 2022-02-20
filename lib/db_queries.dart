import 'dart:async';
import 'package:flutterapplatinlist/constants.dart';
import 'package:flutterapplatinlist/model.dart';
import 'package:sqflite/sqflite.dart';

import 'db_helper.dart';

ListDBHelper con = ListDBHelper();

class ListDBQueries {
  final String _dbTable = Constants.listTBName;

  Future<List<CustomModel>> getSearchList(String text) async {
    List<CustomModel> modelList = [];
    if (text.isNotEmpty) {
      final db = await con.db;
      var res = await db
          .rawQuery(
              "SELECT * FROM $_dbTable WHERE word LIKE '%$text%' ORDER BY word");
      modelList =
          res.isNotEmpty ? res.map((e) => CustomModel.fromMap(e)).toList() : [];
    }
    return modelList;
  }

  // Future<int> getCount() async {
  //   final db = await con.db;
  //   return Sqflite.firstIntValue(
  //       await db.rawQuery('SELECT COUNT(*) FROM $_dbTable'));
  // }
}
