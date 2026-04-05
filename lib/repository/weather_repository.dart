import 'package:weather_app/data/city_local_store.dart';
import 'package:weather_app/data/weather_api_implementation.dart';
import 'package:weather_app/models/city_model.dart';
import 'package:weather_app/models/city_weather_model.dart';

abstract class WeatherRepository {
  Future<List<City>> getCityList();
  Future<City> saveCity(String cityName);
  Future<City> deleteCity(int cityID);
  Future<CityWeather> fetchCityWeatherDetails(City city);
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
  
  @override
  Future<CityWeather> fetchCityWeatherDetails(City city) async {
    final currentWeather = await _apiImplementation.fetchCurrentWeather(city.name);
    final weatherForecast = await _apiImplementation.fetchForecastWeather(city.name);

    return CityWeather.fromApiMaps (
      id: city.id, 
      name: city.name, 
      currentJson: currentWeather, 
      forecastJson: weatherForecast
    );
  }
  
}