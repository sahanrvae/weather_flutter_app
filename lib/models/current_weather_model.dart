class CurrentWeather {
  final String cityLabel;
  final double tempC;
  final String conditionText;
  final String iconUrl;
  final int humidity;
  final double windKph;

  const CurrentWeather({
    required this.cityLabel,
    required this.tempC,
    required this.conditionText,
    required this.iconUrl,
    required this.humidity,
    required this.windKph,
  });

  factory CurrentWeather.fromCurrentJson(Map<String, dynamic> json) {
    final loc = json['location'] as Map<String, dynamic>? ?? {};
    final cur = json['current'] as Map<String, dynamic>? ?? {};
    final cond = cur['condition'] as Map<String, dynamic>? ?? {};
    final icon = (cond['icon'] as String?) ?? '';
    return CurrentWeather(
      cityLabel: '${loc['name'] ?? ''}, ${loc['country'] ?? ''}'.trim(),
      tempC: (cur['temp_c'] as num?)?.toDouble() ?? 0,
      conditionText: cond['text'] as String? ?? '',
      iconUrl: icon.startsWith('//') ? 'https:$icon' : icon,
      humidity: (cur['humidity'] as num?)?.toInt() ?? 0,
      windKph: (cur['wind_kph'] as num?)?.toDouble() ?? 0,
    );
  }
}