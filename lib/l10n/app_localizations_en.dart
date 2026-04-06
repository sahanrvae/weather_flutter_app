// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Weather';

  @override
  String get app_title => 'Weather App';

  @override
  String get refresh_All_Tool_Tip => 'Refresh All';

  @override
  String get enter_city_name => 'Enter City Name';

  @override
  String get city_name_hint => 'e.g. Colombo';

  @override
  String get add => 'Add';

  @override
  String get error_empty_city_name => 'City name is empty';

  @override
  String error_city_already_exists(Object name) {
    return '$name already exists';
  }

  @override
  String get error_city_not_found => 'City not found';

  @override
  String get error_city_delete_failed => 'Failed to delete city';

  @override
  String get error_api_general_fail => 'Somthing went wrong';

  @override
  String get add_city_placeholder => 'Add new city to see weather...';

  @override
  String get weather_card_swipe_instruction => 'Swipe left to remove | Tap for forecast';

  @override
  String get weather_card_refresh_button_tooltip => 'Refresh';

  @override
  String city_picker_city_add_success(Object name) {
    return '$name added successfully!';
  }

  @override
  String get cities_screen_add_city_button => 'Add City';

  @override
  String get city_delete_confirmation_dialog_title => 'Delete City';

  @override
  String city_delete_confirmation_dialog_description(Object city_name) {
    return 'Are you sure you want to delete $city_name';
  }

  @override
  String get button_cancel => 'Cancel';

  @override
  String get button_delete => 'Delete';
}
