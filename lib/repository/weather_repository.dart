import 'package:weather_app/data/city_local_store.dart';
import 'package:weather_app/data/weather_api_implementation.dart';
import 'package:weather_app/models/city_model.dart';

abstract class WeatherRepository {
  Future<List<City>> getCityList();
  Future<City> saveCity(String cityName);
  Future<void> deleteCity(int cityID);
}

class WeatherRepositoryImplement implements WeatherRepository {

  final CityLocalStore _cityLocalStore;
  final WeatherApiImplementation _apiImplementation;

  WeatherRepositoryImplement({
    required CityLocalStore cityLocalStore, 
    required WeatherApiImplementation apiImplementation
    }) : _cityLocalStore = cityLocalStore, _apiImplementation = apiImplementation;


  @override
  Future<City> deleteCity(int cityID) {
    return _cityLocalStore.deleteCity(cityID);
  }

  @override
  Future<List<City>> getCityList() {
    return _cityLocalStore.fetchAllCities();
  }

  @override
  Future<City> saveCity(String cityName) {
    return _cityLocalStore.saveCity(cityName);
  }
  
}