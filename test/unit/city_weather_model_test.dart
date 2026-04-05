import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/models/city_weather_model.dart';
import '../helper/fixtures.dart';

void main() {
  late CityWeather cityWeather;

  setUpAll(() {
    cityWeather = CityWeather.fromApiMaps(
      id: 42,
      name: 'Colombo',
      currentJson: currentWeatherJson(),   
      forecastJson: forecastWeatherJson(),
    );
  });

  test('id is taken from the parameter, not the JSON', () {
    expect(cityWeather.id, 42);
  });
  
  test('name is taken from the parameter', () {
    expect(cityWeather.name, 'Colombo');
  });
  
  test('current weather is populated from current_weather.json', () {
    expect(cityWeather.current.tempC, 29.2);
    expect(cityWeather.current.conditionText, 'Partly cloudy');
  });
}
