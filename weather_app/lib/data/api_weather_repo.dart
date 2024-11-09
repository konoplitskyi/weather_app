import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/data/my_data.dart';
import 'package:weather_app/domain/repository/weather_repository.dart';

class ApiWeatherRepo implements WeatherRepo {
  @override
  Future<Weather> fetchWeather(Position position) async {
    try {
      WeatherFactory wf = WeatherFactory(API_KEY, language: Language.ENGLISH);
      final Weather weather = await wf.currentWeatherByLocation(
        position.latitude,
        position.longitude,
      );

      return weather;
    } catch (e) {
      throw Exception('Fetch weather failed: $e');
    }
  }
}
