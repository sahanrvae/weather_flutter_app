// Import City Model
import 'package:path/path.dart' as location;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:weather_app/config/api_config.dart';

import '../models/city_model.dart';

class CityLocalStore {
  static final String _dbName = AppConfig.localDbName;
  static const _table = 'cties';
  static final cities_table_query = '''CREATE TABLE $_table (
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    name TEXT NOT NULL UNIQUE
  )''';
  //Sqflite data base instance
  Database? _db;

  Future<Database> get database async {
    if (_db == null) {
      final dir = await getApplicationDocumentsDirectory();
      final path = location.join(dir.path, _dbName);
      // Create table if empty
      _db = await openDatabase( 
        path,
        version: 1,
        onCreate:(db, version) async {
          await db.execute(cities_table_query);
        },
      );
    } 
    return _db!;
  }

}