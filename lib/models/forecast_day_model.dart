class ForecastDay {
  final String date;
  final double maxTempC;
  final double minTempC;
  final String conditionText;
  final String iconUrl;

  const ForecastDay({
    required this.date,
    required this.maxTempC,
    required this.minTempC,
    required this.conditionText,
    required this.iconUrl,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    final day = json['day'] as Map<String, dynamic>? ?? {};
    final cond = day['condition'] as Map<String, dynamic>? ?? {};
    final icon = (cond['icon'] as String?) ?? '';
    return ForecastDay(
      date: json['date'] as String? ?? '',
      maxTempC: (day['maxtemp_c'] as num?)?.toDouble() ?? 0,
      minTempC: (day['mintemp_c'] as num?)?.toDouble() ?? 0,
      conditionText: cond['text'] as String? ?? '',
      iconUrl: icon.startsWith('//') ? 'https:$icon' : icon,
    );
  }
}