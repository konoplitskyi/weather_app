class WeatherModel {
  final String areaName;
  final int weatherConditionCode;
  final double tempmerature;
  final String weatherMain;
  final DateTime date;
  final DateTime sunrise;
  final DateTime sunset;
  final double tempMax;
  final double tempMin;

  WeatherModel({
    required this.areaName,
    required this.weatherConditionCode,
    required this.tempmerature,
    required this.weatherMain,
    required this.date,
    required this.sunrise,
    required this.sunset,
    required this.tempMax,
    required this.tempMin,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      areaName: json['name'],
      weatherConditionCode: json['weather'][0]['id'],
      tempmerature: _kelvinToCelsius(json['main']['temp'].toDouble()),
      weatherMain: json['weather'][0]['main'],
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      sunrise:
          DateTime.fromMillisecondsSinceEpoch(json['sys']['sunrise'] * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000),
      tempMax: _kelvinToCelsius(json['main']['temp_max'].toDouble()),
      tempMin: _kelvinToCelsius(json['main']['temp_min'].toDouble()),
    );
  }

  static double _kelvinToCelsius(double kelvin) {
    return kelvin - 273.15;
  }
}
