import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/extensions/l10n_extension.dart';
import 'package:weather_app/provider/weather_cities_provider.dart';
import 'package:weather_app/resources/app_colors.dart';

class CityPickerWidget extends StatefulWidget {
  const CityPickerWidget({super.key});

  @override
  State<CityPickerWidget> createState() => _CityPickerWidgetState();
}

class _CityPickerWidgetState extends State<CityPickerWidget> {
  final _cityNameController = TextEditingController();
  bool _submitting = false;
  bool get _canSubmit =>
      !_submitting && _cityNameController.text.trim().isNotEmpty;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cityNameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _cityNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _cityNameController,
          textInputAction: TextInputAction.done,
          onSubmitted: (value) {
            if (_canSubmit) {
              print(_cityNameController.text);
            }
          },
          enabled: !_submitting,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: context.l10n.enter_city_name,
            labelStyle: TextStyle(color: AppColors.darkBlue),
            hintText: context.l10n.city_name_hint,
          ),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _canSubmit ? _saveCity : null,
          child: _submitting? const SizedBox(
            height: 20, 
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
            ) : Text(context.l10n.add),
        ),
      ],
    );
  }

  Future<void> _saveCity() async {
      if (_canSubmit) {
        final cityName = _cityNameController.text.trim();
        final messenger = ScaffoldMessenger.of(context);
        final colorScheme = Theme.of(context).colorScheme;
        setState(() {
          _submitting = true;
        }); 
        try {
          await context.read<WeatherCitiesProvider>().addNewCity(cityName);
          if (mounted) {
            _cityNameController.clear();
            Navigator.pop(context);
            messenger.showSnackBar(
              SnackBar(
                content: Text(context.l10n.city_picker_city_add_success(cityName)),
                )
            );
          }

        } catch (e) {
          if (mounted) {
            messenger.showSnackBar(
              SnackBar(
                content: Text(e.toString()),
                backgroundColor: colorScheme.error,
              ),
            );
          }
        } finally {
          if (mounted) {
            setState(() {
              _submitting = false;
            });
          }
        }
      } 
      return;
  }
}
