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
}
