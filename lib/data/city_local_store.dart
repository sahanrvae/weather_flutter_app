// Import City Model
import 'package:path/path.dart' as location;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:weather_app/config/api_config.dart';
import 'package:weather_app/data/app_local_db.dart';
import 'package:weather_app/data/city_dao.dart';
import 'package:weather_app/globals.dart';

import '../models/city_model.dart';

class CityLocalStore implements CityDao {
  final AppLocalDb _appLocalDb = AppLocalDb();
  final String _table = AppLocalDb.table;

  // Save city by name to DB
  Future<City> saveCity(String name) async {
    final _name = name.trim();

    if (!_name.isEmpty) {
      final db = await _appLocalDb.database;
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
    final db = await _appLocalDb.database;
    final citiesDictionery = await db.query(
      _table,
      orderBy: AppLocalDb.cities_table_sort_query,
    );
    return citiesDictionery.map(City.fromMap).toList();
  }

  // Delete city by id
  Future<City> deleteCity(int id) async {
    final db = await _appLocalDb.database;
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
