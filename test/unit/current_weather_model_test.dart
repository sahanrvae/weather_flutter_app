import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/models/current_weather_model.dart';
import '../helper/fixtures.dart';

void main() {
  late Map<String, dynamic> json;
  late CurrentWeather weather;

  setUpAll(() {
    json = currentWeatherJson(); 
    weather = CurrentWeather.fromCurrentJson(json);
  });

  test('cityLabel is composed from location name and country', () {
    expect(weather.cityLabel, 'Colombo, Sri Lanka');
  });

  test('tempC matches value in JSON', () {
    expect(weather.tempC, 29.2);
  });

  test('conditionText matches value in JSON', () {
    expect(weather.conditionText, 'Partly cloudy');
  });

  test('humidity matches value in JSON', () {
    expect(weather.humidity, 89);
  });

  test('iconUrl converts protocol-relative URL to https', () {
    expect(weather.iconUrl,
        'https://cdn.weatherapi.com/weather/64x64/night/116.png');
  });
}
