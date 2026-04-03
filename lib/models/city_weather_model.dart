import 'package:weather_app/models/current_weather_model.dart';
import 'package:weather_app/models/forecast_day_model.dart';

class CityWeather {
  final int id;
  final String query;
  final CurrentWeather current;
  final List<ForecastDay> forecastDays;
  
  const CityWeather({
    required this.id,
    required this.query,
    required this.current,
    required this.forecastDays,
  });

  factory CityWeather.fromApiMaps({
    required int id,
    required String query,
    required Map<String, dynamic> currentJson,
    required Map<String, dynamic> forecastJson,
  }) {
    final forecast = forecastJson['forecast'] as Map<String, dynamic>? ?? {};
    final days = (forecast['forecastday'] as List<dynamic>?) ?? [];
    return CityWeather(
      id: id,
      query: query,
      current: CurrentWeather.fromCurrentJson(currentJson),
      forecastDays: days
          .whereType<Map<String, dynamic>>()
          .map(ForecastDay.fromJson)
          .toList(),
    );
  }
}