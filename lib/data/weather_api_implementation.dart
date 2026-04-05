import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/config/api_config.dart';
import 'package:weather_app/globals.dart';

class WeatherApiImplementation {
  final http.Client _client;

  WeatherApiImplementation({http.Client? client})
    : _client = client ?? http.Client();

  // URL path creation by city name
  Uri _uri(String path, Map<String, String> query) {
    final q = Map<String, String>.from(query);
    q['key'] = AppConfig.apiKey;
    return Uri.parse('${AppConfig.baseUrl}/$path').replace(queryParameters: q);
  }

  // Fetch current weather by city
  Future<Map<String, dynamic>> fetchCurrentWeather(String query) async {
    try {
      final res = await _client.get(_uri('current.json', {'q': query}));
      return _handleResponse(res);
    } catch (e) {
      print("${globalL10n?.error_api_general_fail} $e");
      throw HttpException(globalL10n?.error_api_general_fail ?? '');
    }
  }

  // Fetch forcast weather by city
  Future<Map<String, dynamic>> fetchForecastWeather(String query, {int days = 3}) async {
    try {
      final res = await _client.get(_uri('forecast.json', {'q': query, 'days': days.toString()}));
      return _handleResponse(res);
    } catch (e) {
      print("${globalL10n?.error_api_general_fail} $e");
      throw HttpException(globalL10n?.error_api_general_fail ?? '');
    }
  }

  // Handle response
  Map<String, dynamic> _handleResponse(http.Response res) {
    switch (res.statusCode) {
      case >= 200 || <= 300:
        final data = jsonDecode(res.body);
        if (data is! Map<String, dynamic>) {
          throw HttpException('${globalL10n?.error_api_general_fail}: ${res.statusCode}');
        }
        return data;
      default:
        print("${globalL10n?.error_api_general_fail} ${res.statusCode}");
        throw HttpException(globalL10n?.error_api_general_fail ?? '');
    }
  }
}
