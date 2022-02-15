import 'dart:async';
import 'package:flutterapplatinlist/constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CustomDBHelper {
  final String _dbName = Constants.customDBName;
  final String _tbName = Constants.customTBName;

  static final CustomDBHelper _instance = CustomDBHelper.internal();

  factory CustomDBHelper() {
    return _instance;
  }

  static dynamic _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  CustomDBHelper.internal();

  Future<Database> initDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, _dbName);

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) async {},
      onCreate: (Database db, int version) async {
        // Create the table
        await db.execute("""
                CREATE TABLE $_tbName(
                    id INTEGER PRIMARY KEY,
                    word TEXT DEFAULT '',
                    trans TEXT DEFAULT ''
                )
            """);
      },
    );
  }

  Future close() async {
    return _db.close();
  }
}
