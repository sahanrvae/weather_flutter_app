import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/config/api_config.dart';
import 'package:weather_app/data/city_local_store.dart';
import 'package:weather_app/data/weather_api_implementation.dart';
import 'package:weather_app/extensions/l10n_extension.dart';
import 'package:weather_app/l10n/app_localizations.dart';
import 'package:weather_app/models/city_model.dart';
import 'package:weather_app/models/city_weather_model.dart';
import 'package:weather_app/provider/weather_cities_provider.dart';
import 'package:weather_app/resources/app_colors.dart';
import 'package:weather_app/screens/city_weather_forecast_screen.dart';
import 'package:weather_app/widgets/city_card.dart';
import 'package:weather_app/widgets/city_picker_widget.dart';

class CountryListScreen extends StatefulWidget {
  const CountryListScreen({super.key});

  @override
  State<CountryListScreen> createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  final _cityNameController = TextEditingController();
  final CityLocalStore _cityLocalStore = CityLocalStore();
  final WeatherApiImplementation _weatherApiImplementation = WeatherApiImplementation();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllCities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              tooltip: context.l10n.cities_screen_add_city_button,
              onPressed: () {
                _openCityPicker(context);
              },
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 36,
        height: 36,
        child: FloatingActionButton(
            onPressed: () => refreshList(context),
            tooltip: context.l10n.refresh_All_Tool_Tip,
            backgroundColor: Colors.blue.withOpacity(0.4),
            child: const Icon(
              Icons.bolt,
              color: Colors.yellow,
            ),  
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Column(
        children: [
          Expanded(
            child: Consumer<WeatherCitiesProvider>(builder: (context, provider, child) {
                if (provider.cities.isEmpty) {
                  return Center(
                    child: Text(context.l10n.add_city_placeholder, 
                    style: Theme.of(context).textTheme.bodyLarge,),
                  );
                }
                return ListView.builder(
                  itemBuilder:(context, index) {
                    final city = provider.cities[index];
                    final weather = provider.weatherByCityId(city.id);
                    final error_item = provider.errorFor(city.id);
                    final loadingData = provider.isLoading(city.id);
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                      child: CityCard(
                        cityName: city.name, 
                        weather: weather, 
                        error: error_item, 
                        loading: loadingData, 
                        onTap:  () => weather != null ? _openCityWeatherForecast(context, weather) : null, 
                        onRefresh: () => provider.refreshCity(city.id)
                        ),
                    );
                  },
                  itemCount: provider.cities.length,
                  padding: const EdgeInsets.only(bottom: 16),
                );
              }
            ),
          )
        ],
      ),
    );
  }

  void _openCityPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context, 
      builder: (pickercontext) {
        final viewInsets = MediaQuery.viewInsetsOf(pickercontext);
        return AnimatedPadding(
          padding: EdgeInsets.only(bottom: viewInsets.bottom), 
          duration: const Duration(microseconds: 100),
          curve: Curves.easeInOut,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(pickercontext.l10n.cities_screen_add_city_button, style: Theme.of(pickercontext).textTheme.titleLarge),
                const SizedBox(height: 16),
                const CityPickerWidget()
              ],
            ),
          ),
        );
      },
      isScrollControlled: true,
      showDragHandle: true
    );
  }

  void refreshList(BuildContext context) {
    final provider = context.read<WeatherCitiesProvider>();
    for (final city in provider.cities) {
      provider.refreshCity(city.id);
    }
  }

  void _openCityWeatherForecast(BuildContext context, CityWeather weather) {
    Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => CityWeatherForecastScreen(cityWeather: weather)
        )
    );
  }

  Future<City?> addCity(String name) async {
    final trimName = name.trim();
    try {
      final city = await _cityLocalStore.saveCity(trimName);
      return city;
    } on ArgumentError catch (e) {
      // Empty city name
      _showSnackbar(e.message);
      return null;
    } on StateError catch (e) {
      // Duplicate city
      _showSnackbar(e.message);
      return null;
    }
  }

  Future<City?> deleteCity(int id) async {
    try {
      final city = await _cityLocalStore.deleteCity(id);
      return city;
    } on ArgumentError catch (e) {
      // Empty city name
      _showSnackbar(e.message);
      return null;
    } on StateError catch (e) {
      // Duplicate city
      _showSnackbar(e.message);
      return null;
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> getAllCities() async {
    final cities = await _cityLocalStore.fetchAllCities();
    for (final city in cities) {
      print("City Name: ${city.name} ID ${city.id}");
      final currentWeather = await _weatherApiImplementation.fetchCurrentWeather(city.name);
      final forcastWeather = await _weatherApiImplementation.fetchForecastWeather(city.name);
      print("Current Weather: ${currentWeather}");
      print("Forcast Weather: ${forcastWeather}");
    };
  }

  Future<void> _saveCity() async {
    final text = _cityNameController.text;
    if (text.trim().isEmpty) {
      return;
    }
    print("City Name: $text");
    final _city = await addCity(text);
    print("Saved City Name: ${_city?.name ?? ""}");
    // await _deleteCity(1);
  }

  Future<void> _deleteCity(int cityID) async {
    final _city = await deleteCity(cityID);
    print("Saved City Name: ${_city?.name ?? ""}");
  }

}
