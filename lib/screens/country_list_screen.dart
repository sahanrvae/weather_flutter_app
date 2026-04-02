import 'package:flutter/material.dart';
import 'package:weather_app/config/api_config.dart';
import 'package:weather_app/extensions/l10n_extension.dart';
import 'package:weather_app/l10n/app_localizations.dart';
import 'package:weather_app/resources/app_colors.dart';

class CountryListScreen extends StatefulWidget {
  const CountryListScreen({super.key});

  @override
  State<CountryListScreen> createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  final _cityNameController = TextEditingController();
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
              icon: const Icon(Icons.refresh)
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                Expanded(child: TextField(
                  controller: _cityNameController,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _saveCity(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color:  AppColors.darkBlue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color:  AppColors.darkBlue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color:  AppColors.darkBlue, width: 2.0),
                    ),
                    labelText: context.l10n.enter_city_name,
                    labelStyle: TextStyle(color: AppColors.darkBlue),
                    hintText: context.l10n.city_name_hint,
                    isDense: true
                  ),
                  )
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _saveCity, 
                  child: Text(context.l10n.add),
                  style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 46, 100, 250))),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _saveCity() async {
    final text = _cityNameController.text;
    if (text.trim().isEmpty) {
      return;
    }
    print("City Name: $text");
    print('${AppConfig.apiKey}');
  }
}