import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/l10n/app_localizations.dart';
import 'package:weather_app/screens/city_weather_forecast_screen.dart';
import 'package:weather_app/widgets/current_weather_page.dart';
import '../helper/fixtures.dart';

Widget _buildScreen() => MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: CityWeatherForecastScreen(
        cityWeather: mockCityWeatherWithForecast(),
      ),
    );

void _suppressNetworkImageErrors() {
  final original = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.exception is NetworkImageLoadException) return;
    original?.call(details);
  };
}

void main() {
  testWidgets('AppBar shows city label',
      (tester) async {
    _suppressNetworkImageErrors();
    await tester.pumpWidget(_buildScreen());
    await tester.pump();
    expect(find.text('Colombo, Sri Lanka'), findsOneWidget);
  });
  
  testWidgets('CurrentWeatherPage is the first visible page', (tester) async {
    _suppressNetworkImageErrors();
    await tester.pumpWidget(_buildScreen());
    await tester.pump();
    expect(find.byType(CurrentWeatherPage), findsOneWidget);
  });
  
  testWidgets('Temperature displayed',
      (tester) async {
    _suppressNetworkImageErrors();
    await tester.pumpWidget(_buildScreen());
    await tester.pump();
    expect(find.textContaining('29.2°C'), findsOneWidget);
  });
  
  testWidgets(
      'Page indicator shows indicaters',
      (tester) async {
    _suppressNetworkImageErrors();
    await tester.pumpWidget(_buildScreen());
    await tester.pump();
    expect(find.byIcon(Icons.circle), findsNWidgets(3));
  });

  testWidgets('Condition text is displayed',
      (tester) async {
    _suppressNetworkImageErrors();
    await tester.pumpWidget(_buildScreen());
    await tester.pump();
    expect(find.text('Partly cloudy'), findsOneWidget);
  });
}
