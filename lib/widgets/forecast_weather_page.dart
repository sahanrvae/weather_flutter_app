import 'package:flutter/material.dart';
import 'package:weather_app/models/forecast_day_model.dart';

class ForecastWeatherPage extends StatelessWidget {
  final ForecastDay forecast;
  const ForecastWeatherPage({required this.forecast});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 2
          ),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
          child: Column(
            children: [
              Text(
                forecast.date,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (forecast.iconUrl.isNotEmpty)
                Image.network(forecast.iconUrl, width: 100, height: 100)
              else
                const SizedBox(height: 100),
              Text(forecast.conditionText),
              const SizedBox(height: 16),
              Text(
                "High ${forecast.maxTempC.round()}°C  |  Low ${forecast.minTempC.round()}°C",
                style: Theme.of(context).textTheme.titleLarge,
              )
            ], 
          ),
        ),
      ),
    );
  }
}