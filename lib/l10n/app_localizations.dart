import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get appTitle;

  /// No description provided for @refresh_All_Tool_Tip.
  ///
  /// In en, this message translates to:
  /// **'Refresh All'**
  String get refresh_All_Tool_Tip;

  /// No description provided for @enter_city_name.
  ///
  /// In en, this message translates to:
  /// **'Enter City Name'**
  String get enter_city_name;

  /// No description provided for @city_name_hint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Colombo'**
  String get city_name_hint;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @error_empty_city_name.
  ///
  /// In en, this message translates to:
  /// **'City name is empty'**
  String get error_empty_city_name;

  /// No description provided for @error_city_already_exists.
  ///
  /// In en, this message translates to:
  /// **'{name} already exists'**
  String error_city_already_exists(Object name);

  /// No description provided for @error_city_not_found.
  ///
  /// In en, this message translates to:
  /// **'City not found'**
  String get error_city_not_found;

  /// No description provided for @error_city_delete_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete city'**
  String get error_city_delete_failed;

  /// No description provided for @error_api_general_fail.
  ///
  /// In en, this message translates to:
  /// **'Somthing went wrong'**
  String get error_api_general_fail;

  /// No description provided for @add_city_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Add new city to see weather...'**
  String get add_city_placeholder;

  /// No description provided for @weather_card_swipe_instruction.
  ///
  /// In en, this message translates to:
  /// **'Swipe left to remove | Tap for forecast'**
  String get weather_card_swipe_instruction;

  /// No description provided for @weather_card_refresh_button_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get weather_card_refresh_button_tooltip;

  /// No description provided for @city_picker_city_add_success.
  ///
  /// In en, this message translates to:
  /// **'{name} added successfully!'**
  String city_picker_city_add_success(Object name);

  /// No description provided for @cities_screen_add_city_button.
  ///
  /// In en, this message translates to:
  /// **'Add City'**
  String get cities_screen_add_city_button;

  /// No description provided for @city_delete_confirmation_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Delete City'**
  String get city_delete_confirmation_dialog_title;

  /// No description provided for @city_delete_confirmation_dialog_description.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {city_name}'**
  String city_delete_confirmation_dialog_description(Object city_name);

  /// No description provided for @button_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get button_cancel;

  /// No description provided for @button_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get button_delete;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
