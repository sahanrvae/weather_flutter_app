import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:weather_app/l10n/app_localizations.dart';
import 'package:weather_app/provider/weather_cities_provider.dart';
import 'package:weather_app/screens/city_weather_forecast_screen.dart';
import 'package:weather_app/screens/country_list_screen.dart';
import 'package:weather_app/widgets/city_card.dart';
import '../helper/fixtures.dart';
import '../mocks.mocks.dart';

Widget _buildScreen(WeatherCitiesProvider provider) {
  return ChangeNotifierProvider<WeatherCitiesProvider>.value(
    value: provider,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const CountryListScreen(),
    ),
  );
}

Future<WeatherCitiesProvider> _providerWithOneCity() async {
  final repo = MockWeatherRepository();
  when(repo.getCityList())
      .thenAnswer((_) async => [mockCity(id: 1, name: 'Colombo')]);
  when(repo.fetchCityWeatherDetails(argThat(isA())))
      .thenAnswer((_) async => mockCityWeather(id: 1, name: 'Colombo'));
  final provider = WeatherCitiesProvider(repository: repo);
  await provider.fetchInitialWeatherDetails();
  return provider;
}

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final tmp = Directory.systemTemp.path;
    for (final ch in const [
      'plugins.flutter.io/path_provider',
      'plugins.flutter.io/path_provider_macos',
      'plugins.flutter.io/path_provider_foundation',
    ]) {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(MethodChannel(ch), (_) async => tmp);
    }
  });
  
  testWidgets('Shows "Weather" as title', (tester) async {
    final repo = MockWeatherRepository();
    when(repo.getCityList()).thenAnswer((_) async => []);
    final provider = WeatherCitiesProvider(repository: repo);
    await provider.fetchInitialWeatherDetails();
    await tester.pumpWidget(_buildScreen(provider));
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.text('Weather'), findsOneWidget);
  });
  
  testWidgets('CityCard showing the city name',
      (tester) async {
    final provider = await _providerWithOneCity();
    await tester.pumpWidget(_buildScreen(provider));
    await tester.pump();
    expect(find.byType(CityCard), findsOneWidget);
    expect(find.text('Colombo'), findsOneWidget);
  });

  testWidgets('CityCard shows condition',
      (tester) async {
    final provider = await _providerWithOneCity();
    await tester.pumpWidget(_buildScreen(provider));
    await tester.pump();
    expect(find.text('Partly cloudy'), findsOneWidget);
  });

  testWidgets('Tapping CityCard navigate to forecast screen',
      (tester) async {
    final provider = await _providerWithOneCity();
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exception is NetworkImageLoadException) return;
      originalOnError?.call(details);
    };
    await tester.pumpWidget(_buildScreen(provider));
    await tester.pump();
    await tester.tap(find.byType(InkWell).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(CityWeatherForecastScreen), findsOneWidget);
    FlutterError.onError = originalOnError;
  });
}
