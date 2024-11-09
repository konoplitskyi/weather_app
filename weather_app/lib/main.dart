import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/presentation/cubit/weather_cubit.dart';
import 'package:weather_app/data/api_weather_repo.dart';
import 'package:weather_app/presentation/pages/home_page.dart';
import 'package:weather_app/presentation/utils/determine_position.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiWeatherRepo = ApiWeatherRepo();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: determinePosition(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final position = snapshot.data!;
              return BlocProvider<WeatherCubit>(
                create: (context) => WeatherCubit(weatherRepo: apiWeatherRepo)
                  ..fetchWeather(position),
                child: const HomePage(),
              );
            } else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }),
    );
  }
}
