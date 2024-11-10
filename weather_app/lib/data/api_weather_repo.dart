import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/data/my_data.dart';
import 'package:weather_app/domain/enitites/weather_model.dart';
import 'package:weather_app/domain/repository/weather_repository.dart';
import 'package:http/http.dart' as http;

class ApiWeatherRepo implements WeatherRepo {
  static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';

  @override
  Future<WeatherModel> fetchWeatherOrigin(Position position) async {
    try {
      final response = await http.get(Uri.parse(
          '$BASE_URL?lat=${position.latitude}&lon=${position.longitude}&exclude=current&appid=$API_KEY'));
      if (response.statusCode == 200) {
        print(response.body);
        return WeatherModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Bad response from api with statud code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Fetch weather failed: $e');
    }
  }

  @override
  Future<Weather> fetchWeather(Position position) async {
    try {
      WeatherFactory wf = WeatherFactory(API_KEY, language: Language.ENGLISH);
      final Weather weather = await wf.currentWeatherByLocation(
        position.latitude,
        position.longitude,
      );
      print(weather);
      return weather;
    } catch (e) {
      throw Exception('Fetch weather failed: $e');
    }
  }

  @override
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
