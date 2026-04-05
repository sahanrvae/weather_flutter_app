import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class AppConfig {
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
  static String get localDbName => 'weather_app.db';
}