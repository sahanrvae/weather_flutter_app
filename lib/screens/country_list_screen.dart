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
                      child: Dismissible(
                        key: ValueKey("city-${city.id}"),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Theme.of(context).colorScheme.errorContainer,
                          child: Icon(
                            Icons.delete_outline,
                            color: Theme.of(context).colorScheme.onErrorContainer,
                          ),
                        ),
                        confirmDismiss: (_) async {
                          return await showDeleteConfirmation(context, city.name);
                        },
                        onDismissed: (_) {
                            context.read<WeatherCitiesProvider>().removeCityByID(city.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Remove ${city.name}"))
                            );
                        },
                        child: CityCard(
                          cityName: city.name, 
                          weather: weather, 
                          error: error_item, 
                          loading: loadingData, 
                          onTap:  () => weather != null ? _openCityWeatherForecast(context, weather) : null, 
                          onRefresh: () => provider.refreshCity(city.id)
                          ),
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

  Future<bool> showDeleteConfirmation(BuildContext context, String cityName) async {
    final confirmation = await showDialog(
      context: context, 
      builder: (alertcontext) => AlertDialog(
        title: Text(alertcontext.l10n.city_delete_confirmation_dialog_title),
        content: Text(alertcontext.l10n.city_delete_confirmation_dialog_description(cityName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), 
            child: Text(alertcontext.l10n.button_cancel)
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            child: Text(alertcontext.l10n.button_delete),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
      )
    );
    return confirmation;
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

}
