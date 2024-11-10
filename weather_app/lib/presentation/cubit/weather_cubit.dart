import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
//import 'package:weather/weather.dart';
import 'package:weather_app/domain/enitites/weather_model.dart';
import 'package:weather_app/domain/repository/weather_repository.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepo weatherRepo;
  WeatherCubit({required this.weatherRepo}) : super(WeatherInitial());

  Future<void> fetchWeather() async {
    emit(WeatherLoading());
    try {
      final position = await weatherRepo.getCurrentPosition();
      //Weather weather = await weatherRepo.fetchWeather(position);// when use "weather" package
      final weatherModel = await weatherRepo.fetchWeatherOrigin(position);
      emit(WeatherLoaded(weatherModel));
    } catch (e) {
      emit(WeatherFailure());
    }
  }
}
