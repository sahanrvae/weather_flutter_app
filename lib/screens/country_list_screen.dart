import 'package:flutter/material.dart';
import 'package:weather_app/extensions/l10n_extension.dart';
import 'package:weather_app/l10n/app_localizations.dart';

class CountryListScreen extends StatefulWidget {
  const CountryListScreen({super.key});

  @override
  State<CountryListScreen> createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appTitle),
      ),
    );
  }
}