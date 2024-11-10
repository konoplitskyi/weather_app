import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/domain/enitites/weather_model.dart';

abstract class WeatherRepo {
  Future<Weather> fetchWeather(Position position);
  Future<WeatherModel> fetchWeatherOrigin(Position position);
  Future<Position> getCurrentPosition();
}
