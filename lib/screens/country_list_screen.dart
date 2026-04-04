import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/config/api_config.dart';
import 'package:weather_app/data/city_local_store.dart';
import 'package:weather_app/data/weather_api_implementation.dart';
import 'package:weather_app/extensions/l10n_extension.dart';
import 'package:weather_app/l10n/app_localizations.dart';
import 'package:weather_app/models/city_model.dart';
import 'package:weather_app/provider/weather_cities_provider.dart';
import 'package:weather_app/resources/app_colors.dart';
import 'package:weather_app/widgets/city_card.dart';

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
              tooltip: context.l10n.refresh_All_Tool_Tip,
              onPressed: () {
                print("Refresh All Data");
              },
              icon: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityNameController,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _saveCity(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.darkBlue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.darkBlue),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.darkBlue,
                          width: 2.0,
                        ),
                      ),
                      labelText: context.l10n.enter_city_name,
                      labelStyle: TextStyle(color: AppColors.darkBlue),
                      hintText: context.l10n.city_name_hint,
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _saveCity,
                  child: Text(context.l10n.add),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      const Color.fromARGB(255, 46, 100, 250),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                    return CityCard(
                      cityName: city.name, 
                      weather: weather, 
                      error: error_item, 
                      loading: loadingData, 
                      onTap:  () => print(city), 
                      onRefresh: () => provider.refreshCity(city.id)
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
    await _deleteCity(1);
  }

  Future<void> _deleteCity(int cityID) async {
    final _city = await deleteCity(cityID);
    print("Saved City Name: ${_city?.name ?? ""}");
  }

}
