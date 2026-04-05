import 'package:flutter/material.dart';
import 'package:weather_app/models/current_weather_model.dart';

class CurrentWeatherPage extends StatelessWidget {
  final CurrentWeather current;
  const CurrentWeatherPage({super.key, required this.current});

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
              if (current.iconUrl.isNotEmpty)
                Image.network(current.iconUrl, width: 120, height: 120)
              else
                const SizedBox(height: 120),
                Text("Now",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  "${current.tempC}°C",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Text(current.conditionText),
                const SizedBox(height: 16),
                Align(
                  alignment: .centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Humidity: ${current.humidity}"),
                      Text("Wind: ${current.windKph} km/h"),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}