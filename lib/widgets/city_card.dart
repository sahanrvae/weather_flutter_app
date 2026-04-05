import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/extensions/l10n_extension.dart';
import 'package:weather_app/models/city_weather_model.dart';

class CityCard extends StatelessWidget {
  const CityCard({
    required this.cityName,
    required this.weather,
    required this.error,
    required this.loading,
    required this.onTap,
    required this.onRefresh,
  });

  final String cityName;
  final CityWeather? weather;
  final String? error;
  final bool loading;
  final VoidCallback? onTap;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      cityName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    tooltip: context.l10n.weather_card_refresh_button_tooltip,
                    onPressed: onRefresh,
                    icon: loading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh),
                  ),
                ],
              ),
              if (error != null && weather == null)
                Text(
                  error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              if (weather != null) ...[
                Row(
                  children: [
                    if (weather!.current.iconUrl.isNotEmpty)
                      Image.network(
                        weather!.current.iconUrl,
                        width: 64,
                        height: 64,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox(width: 64, height: 64),
                      ),
                    const SizedBox(width: 8),
                    Text(
                      '${weather!.current.tempC.round()}°C',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        weather!.current.conditionText,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Humidity ${weather!.current.humidity}% | Wind ${weather!.current.windKph.round()} km/h',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.weather_card_swipe_instruction,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}