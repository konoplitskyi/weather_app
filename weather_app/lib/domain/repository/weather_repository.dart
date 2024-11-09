import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

abstract class WeatherRepo {
  Future<Weather> fetchWeather(Position position);
}
