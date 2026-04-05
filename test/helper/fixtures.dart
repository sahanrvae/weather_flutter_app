import 'dart:convert';
import 'dart:io';

import 'package:weather_app/models/city_model.dart';
import 'package:weather_app/models/city_weather_model.dart';
import 'package:weather_app/models/current_weather_model.dart';
import 'package:weather_app/models/forecast_day_model.dart';

Map<String, dynamic> currentWeatherJson() =>
    jsonDecode(File('test/current_weather.json').readAsStringSync())
        as Map<String, dynamic>;

Map<String, dynamic> forecastWeatherJson() =>
    jsonDecode(File('test/forecat_weather.json').readAsStringSync())
        as Map<String, dynamic>;

City mockCity({int id = 1, String name = 'Colombo'}) =>
    City(id: id, name: name);

CurrentWeather mockCurrentWeather() =>
    CurrentWeather.fromCurrentJson(currentWeatherJson());

CityWeather mockCityWeather({int id = 1, String name = 'Colombo'}) =>
    CityWeather.fromApiMaps(
      id: id,
      name: name,
      currentJson: currentWeatherJson(),
      forecastJson: forecastWeatherJson(),
    );

CityWeather mockCityWeatherWithForecast({int id = 1, String name = 'Colombo'}) =>
    CityWeather(
      id: id,
      name: name,
      current: mockCurrentWeather(),
      forecastDays: [
        ForecastDay(
          date: '2026-04-06',
          maxTempC: 30.7,
          minTempC: 27.7,
          conditionText: 'Heavy rain',
          iconUrl: 'https://cdn.weatherapi.com/weather/64x64/day/308.png',
        ),
        ForecastDay(
          date: '2026-04-07',
          maxTempC: 30.7,
          minTempC: 27.7,
          conditionText: 'Heavy rain',
          iconUrl: 'https://cdn.weatherapi.com/weather/64x64/day/308.png',
        ),
      ],
    );
