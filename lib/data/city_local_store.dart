// Import City Model
import 'package:path/path.dart' as location;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:weather_app/config/api_config.dart';
import 'package:weather_app/globals.dart';

import '../models/city_model.dart';

class CityLocalStore {
  static final String _dbName = AppConfig.localDbName;
  static const _table = 'cties';
  static final cities_table_query = '''CREATE TABLE $_table (
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    name TEXT NOT NULL UNIQUE
  )''';
  static final cities_table_sort_query = '''name COLLATE NOCASE ASC''';
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
        onCreate: (db, version) async {
          await db.execute(cities_table_query);
        },
      );
    }
    return _db!;
  }

  // Save city by name to DB
  Future<City> saveCity(String name) async {
    final _name = name.trim();

    if (!_name.isEmpty) {
      final db = await database;
      // Check if city already exists
      final existing = await db.query(
        _table,
        where: 'name = ? COLLATE NOCASE',
        whereArgs: [_name],
      );
      // If exist throw errorr
      if (existing.isNotEmpty) {
        throw StateError(
          globalL10n?.error_city_already_exists(_name) ??
              '$_name already exist',
        );
      }
      // Not exist add new city
      final id = await db.insert(_table, {'name': _name});
      return City(id: id, name: _name);
    } else {
      throw ArgumentError(globalL10n?.error_empty_city_name);
    }
  }

  // Fetch cities
  Future<List<City>> fetchAllCities() async {
    final db = await database;
    final citiesDictionery = await db.query(
      _table,
      orderBy: cities_table_sort_query,
    );
    return citiesDictionery.map(City.fromMap).toList();
  }

  // Delete city by id
  Future<City> deleteCity(int id) async {
    final db = await database;
    final existing = await db.query(_table, where: 'id = ?', whereArgs: [id]);
    // Check if the city is exist in the db
    if (existing.isEmpty) {
      throw StateError(globalL10n?.error_city_not_found ?? 'City not found');
    }
    // If exist delete the city by id
    final deletedCity = City.fromMap(existing.first);
    final affectedRows = await db.delete(
      _table,
      where: 'id = ?',
      whereArgs: [id],
    );
    // City delete failed
    if (affectedRows == 0) {
      throw StateError(
        globalL10n?.error_city_delete_failed ?? 'Failed to delete city',
      );
    }

    return deletedCity;
  }
}
