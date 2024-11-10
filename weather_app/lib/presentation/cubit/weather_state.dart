part of 'weather_cubit.dart';

sealed class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

final class WeatherInitial extends WeatherState {}

final class WeatherLoading extends WeatherState {}

final class WeatherLoaded extends WeatherState {
  //final Weather weather; // when use "weather packege"
  final WeatherModel weather;

  const WeatherLoaded(this.weather);
}

final class WeatherFailure extends WeatherState {}
