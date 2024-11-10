part of 'weather_cubit.dart';

abstract class WeatherState {}

final class WeatherInitial extends WeatherState {}

final class WeatherLoading extends WeatherState {}

final class WeatherLoaded extends WeatherState {
  //final Weather weather; // when use "weather" package
  final WeatherModel weather;

  WeatherLoaded(this.weather);
}

final class WeatherFailure extends WeatherState {}
