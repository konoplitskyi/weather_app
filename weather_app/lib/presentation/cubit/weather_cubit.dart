import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/domain/repository/weather_repository.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepo weatherRepo;
  Position? _position;

  WeatherCubit({required this.weatherRepo}) : super(WeatherInitial());

  Future<void> fetchWeather(Position position) async {
    emit(WeatherLoading());
    try {
      _position ??= position;
      Weather weather = await weatherRepo.fetchWeather(position);
      print(weather);
      emit(WeatherLoaded(weather));
    } catch (e) {
      print(e.toString());
      emit(WeatherFailure());
    }
  }

  Future<void> updateWeather() async {
    fetchWeather(_position!);
  }
}
