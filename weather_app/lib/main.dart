import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/presentation/cubit/weather_cubit.dart';
import 'package:weather_app/data/api_weather_repo.dart';
import 'package:weather_app/presentation/pages/home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiWeatherRepo = ApiWeatherRepo();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider<WeatherCubit>(
        create: (context) =>
            WeatherCubit(weatherRepo: apiWeatherRepo)..fetchWeather(),
        child: const HomePage(),
      ),
    );
  }
}
