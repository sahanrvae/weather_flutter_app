import 'package:flutter/material.dart';
import 'package:weather_app/models/city_weather_model.dart';
import 'package:weather_app/resources/app_colors.dart';
import 'package:weather_app/widgets/current_weather_page.dart';
import 'package:weather_app/widgets/forecast_weather_page.dart';

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
    final foreCastWeather = widget.cityWeather.forecastDays;
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
          ),
          const SizedBox(height: 8),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (i) => setState(() {
                _pageNumber = i;
              }),
              children: [
                CurrentWeatherPage(current: currentWeather),
                for (final forecastday in widget.cityWeather.forecastDays)
                    ForecastWeatherPage(forecast: forecastday)
              ],
            )
          )
        ],
      ),
    );
  }
}