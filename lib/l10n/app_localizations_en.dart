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
}
