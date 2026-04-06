import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/data/city_local_store.dart';
import 'package:weather_app/data/weather_api_implementation.dart';
import 'package:weather_app/extensions/l10n_extension.dart';
import 'package:weather_app/globals.dart';
import 'package:weather_app/l10n/app_localizations.dart';
import 'package:weather_app/provider/weather_cities_provider.dart';
import 'package:weather_app/repository/weather_repository.dart';
import 'package:weather_app/resources/app_colors.dart';
import 'package:weather_app/screens/country_list_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    globalL10n = AppLocalizations.of(context);
    return ChangeNotifierProvider(
      create: (BuildContext context) {  
        final weatherRepository = WeatherRepositoryImplement(
          cityLocalStore: CityLocalStore(), 
          apiImplementation: WeatherApiImplementation()
          );
        final provider = WeatherCitiesProvider(repository: weatherRepository);
        provider.fetchInitialWeatherDetails();
        return provider;
      },
      child: MaterialApp(
        title: globalL10n?.appTitle,
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData.dark(),
        theme: ThemeData(
          colorScheme: .fromSeed(seedColor: AppColors.darkBlue),
          useMaterial3: true,
        ),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,  
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const CountryListScreen(),
      ),
    );
  }
}
