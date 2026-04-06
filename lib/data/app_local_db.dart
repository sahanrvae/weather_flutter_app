import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as location;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:weather_app/config/api_config.dart';
import 'package:weather_app/config/app_constant.dart';
import 'package:weather_app/globals.dart';

class AppLocalDb {
  static final AppLocalDb _instance = AppLocalDb._internal();
  factory AppLocalDb() => _instance;
  AppLocalDb._internal();

  static final String _dbName = AppConfig.localDbName;
  static const table = 'cties';
  static final cities_table_query = '''CREATE TABLE $table (
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    name TEXT NOT NULL UNIQUE
  )''';
  static final cities_table_sort_query = '''name COLLATE NOCASE ASC''';

  Database? _db;

  Future<Database> get database async {
    if (_db == null) {
      final dir = await getApplicationDocumentsDirectory();
      final path = location.join(dir.path, _dbName);
      // Create table if empty
      _db = await openDatabase(
        path,
        version: AppConstant.dbVersion,
        onCreate: (db, version) async {
          await db.execute(cities_table_query);
        },
      );
    }
    return _db!;
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }

}