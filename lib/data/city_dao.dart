import 'package:weather_app/models/city_model.dart';

abstract class CityDao {
  Future<City> saveCity(String name);
  Future<List<City>> fetchAllCities();
  Future<City> deleteCity(int id);
}