import 'package:flutter/material.dart';
import 'package:weather_app/models/city_weather_model.dart';
import 'package:weather_app/resources/app_colors.dart';

class CityWeatherForecastScreen extends StatefulWidget {
  final CityWeather cityWeather;
  
  const CityWeatherForecastScreen({super.key, required this.cityWeather});

  @override
  State<CityWeatherForecastScreen> createState() => _CityWeatherForecastScreenState();
}

class _CityWeatherForecastScreenState extends State<CityWeatherForecastScreen> {
  late final PageController _pageController;
  int _pageNumber = 0;
  int get _pageCount => widget.cityWeather.forecastDays.length + 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentWeather = widget.cityWeather.current;
    final title = currentWeather.cityLabel.isNotEmpty ? currentWeather.cityLabel : widget.cityWeather.name;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          const SizedBox(height: 9),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pageCount, (i) {
              return Padding(
                padding: const EdgeInsetsGeometry.symmetric(horizontal: 3),
                child: Icon(
                  Icons.circle,
                  size: i == _pageNumber ? 10 : 6,
                  color: i == _pageNumber ? AppColors.darkBlue : const Color.fromARGB(255, 123, 123, 123),
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}