import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutterapplatinlist/models/model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  String dbName = 'wordlist.db';
  String dbTable = 't_wordlist';
  String colId = 'id';
  String colWord = 'word';
  String colTranslation = 'trans';

  DBProvider._();

  static final DBProvider db = DBProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDB();
    }
    return _database;
  }

  initDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, dbName);

    var exists = await databaseExists(path);

    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join("assets/db", dbName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Save copied asset to documents
      await File(path).writeAsBytes(bytes, flush: true);
    }
    var initDb = await openDatabase(path);
    return initDb;
  }

  Future close() async {
    return _database.close();
  }

  Future<int> insertModel(Model model) async {
    Database db = await this.database;
    var res = await db.insert(dbTable, model.toMap());
    return res;
  }

  Future<int> updateModel(Model model) async {
    Database db = await this.database;
    var res = await db.update(dbTable, model.toMap(),
        where: '$colId = ?', whereArgs: [model.id]);
    return res;
  }

  Future<List<Model>> getModelList() async {
    final db = await this.database;
    var res = await db.query(dbTable, orderBy: '$colId DESC');
    List<Model> modelList =
        res.isNotEmpty ? res.map((e) => Model.fromMap(e)).toList() : [];
    return modelList;
  }

  Future<int> deleteModel(int id) async {
    Database db = await this.database;
    return await db.delete(dbTable, where: '$colId = ?', whereArgs: [id]);
  }

  Future<int> getCount() async {
    Database db = await this.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $dbTable'));
  }


}
