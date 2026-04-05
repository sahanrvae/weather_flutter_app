import 'package:flutter/material.dart';
import 'package:weather_app/models/city_model.dart';
import 'package:weather_app/models/city_weather_model.dart';
import 'package:weather_app/repository/weather_repository.dart';

class WeatherCitiesProvider extends ChangeNotifier {

  final WeatherRepository _repository;
  // Listners
  final List<CityWeather?> _weatherDetailsById = [];
  final Map<int, String?> _error = {};
  final Set<int> _loading = {};
  List<City> _cities = [];

  WeatherCitiesProvider({required WeatherRepository repository})
   : _repository = repository;

   String? errorFor(int cityId) => _error[cityId];
   bool isLoading(int cityId) => _loading.contains(cityId);

   List<City> get cities => List.unmodifiable(_cities);

   CityWeather? weatherByCityId(int cityId) {
    final i = _cities.indexWhere((c) => c.id == cityId);
    if (i < 0) {
      return null;
    }
    final weatherCityDetails = i < _weatherDetailsById.length ? _weatherDetailsById[i] : null;
    return weatherCityDetails;
   }

   Future<void> _fetchCityIndex(int cityIndex) async {
    if (cityIndex >= 0 && cityIndex <= _cities.length) {
      final city = _cities[cityIndex];
      final cityId = city.id;
      _loading.add(cityId);
      _error[cityId] = null;
      notifyListeners();
      try {
        final weather = await _repository.fetchCityWeatherDetails(city);
        final indexofCity = _cities.indexWhere((c) => c.id == cityId);
        if (indexofCity >= 0) {
          while (_weatherDetailsById.length <= indexofCity) {
            _weatherDetailsById.add(null);
          }
          _weatherDetailsById[indexofCity] = weather;
          _error[cityId] = null;
        } else {
          return;
        }
      } catch (e) {
        _error[cityId] = e.toString();
      } finally {
        _loading.remove(cityId);
        notifyListeners();
      }
    }
   }

   Future<void> fetchInitialWeatherDetails() async {
    _cities = await _repository.getCityList();
    _weatherDetailsById
      ..clear()
      ..addAll(List<CityWeather?>.filled(_cities.length, null));
      _error.clear();
      _loading.clear();
      notifyListeners();
      for (var i = 0; i < _cities.length; i++) {
        await _fetchCityIndex(i);
      }
   }

   Future<void> addNewCity(String cityName) async {
      final _cityName = cityName.trim();
      if (_cityName.isEmpty) return;
      try {
        final savedCity = await _repository.saveCity(_cityName);
        _cities = [..._cities, savedCity]..sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase())
        );
        notifyListeners();
        final cityIndex = _cities.indexWhere((c) => c.id == savedCity.id);
        if (cityIndex >= 0) {
          await _fetchCityIndex(cityIndex);
        }
      } catch (e, message) {
        print("Add City Error: $e \n $message");
        rethrow;
      }
   }

   Future<void> removeCityByID(int id) async {
    await _repository.deleteCity(id);
    _cities = _cities.where((c) => c.id != id).toList();
    _error.remove(id);
    _loading.remove(id);
    notifyListeners();
   }

   Future<void> refreshCity(int id) async {
    final index = _cities.indexWhere((c) => c.id == id);
    if (index < 0) return;
    await _fetchCityIndex(index);
   }
  
}