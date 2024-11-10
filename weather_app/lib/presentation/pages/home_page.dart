import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/presentation/cubit/weather_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final weatherCubit = context.read<WeatherCubit>();
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 10).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // systemOverlayStyle: const SystemUiOverlayStyle( //not need
        //   statusBarBrightness: Brightness.dark,
        // ),
      ),
      body: Stack(
        children: [
          _backgroundWidget(),
          SafeArea(
            child: LiquidPullToRefresh(
              onRefresh: _handleRefresh,
              backgroundColor: Colors.deepPurple.shade300,
              color: Colors.transparent,
              animSpeedFactor: 3,
              showChildOpacityTransition: false,
              child: BlocBuilder<WeatherCubit, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherLoaded) {
                    final isNight =
                        // state.weather.date!.isBefore(state.weather.sunrise!) ||
                        //         state.weather.date!.isAfter(state.weather.sunset!); //when use "weather" package
                        state.weather.date.isBefore(state.weather.sunrise) ||
                            state.weather.date.isAfter(state.weather.sunset);

                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                AnimatedBuilder(
                                  animation: _controller,
                                  builder: (context, child) {
                                    return Transform.translate(
                                      offset: Offset(0, _animation.value),
                                      child: const Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  //state.weather.areaName!.toUpperCase(), //when use "weather" package
                                  state.weather.areaName.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 100),
                            Column(
                              children: [
                                _getWeatherIcon(
                                  code: state.weather.weatherConditionCode,
                                  isNight: isNight,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  //'${state.weather.temperature!.celsius!.round()}°C', //when use "weather" package
                                  '${state.weather.tempmerature.round()}°C',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  state.weather.weatherMain.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 180),
                            Text(
                              // DateFormat('EEEE dd •')
                              //     .add_jm()
                              //     .format(state.weather.date!), //when use "weather" package
                              DateFormat('EEEE dd •')
                                  .add_jm()
                                  .format(state.weather.date),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                              size: 30,
                            ),
                            const SizedBox(height: 50),
                            _details(
                              sunrise: state.weather.sunrise,
                              sunset: state.weather.sunset,
                              tempMax: state.weather.tempMax,
                              tempMin: state.weather.tempMin,
                            ),
                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    );
                  } else if (state is WeatherLoading) {
                    return _loading();
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailsItem({
    required String path,
    required String title,
    required String data,
  }) {
    return Row(
      children: [
        Image.asset(
          path,
          scale: 8,
        ),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              data,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _details({
    required DateTime sunrise,
    required DateTime sunset,
    required double tempMax,
    required double tempMin,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          const Text(
            'Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _detailsItem(
                path: 'assets/sunrise.png',
                title: 'Sunrise',
                data: DateFormat().add_jm().format(sunrise),
              ),
              _detailsItem(
                path: 'assets/sunset.png',
                title: 'Sunset',
                data: DateFormat().add_jm().format(sunset),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Divider(
              color: Colors.grey,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _detailsItem(
                path: 'assets/temp_max.png',
                title: 'Temp Max',
                data: '${tempMax.round()}°C',
              ),
              _detailsItem(
                path: 'assets/temp_min.png',
                title: 'Temp Min',
                data: '${tempMin.round()}°C',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _loading() {
    return const Center(
      child: SizedBox(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 5,
        ),
      ),
    );
  }

  Widget _backgroundWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        40,
        1.2 * kToolbarHeight,
        40,
        20,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Align(
              alignment: const AlignmentDirectional(5, 0.1),
              child: Container(
                height: 300,
                width: 300,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(-5, 0.1),
              child: Container(
                height: 300,
                width: 300,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0, -1.2),
              child: Container(
                height: 400,
                width: 600,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    await weatherCubit.fetchWeather();
  }

  Widget _getWeatherIcon({
    required final int code,
    required final bool isNight,
  }) {
    late String path;
    switch (code) {
      case >= 200 && < 300:
        if (isNight) {
          path = 'assets/thunderstrom.json';
        } else {
          path = 'assets/thunderstrom_day.json';
        }
      case >= 300 && < 600:
        if (isNight) {
          path = 'assets/rainy_night.json';
        } else {
          path = 'assets/rainy_day.json';
        }
      case >= 600 && < 700:
        if (isNight) {
          path = 'assets/snow_night.json';
        } else {
          path = 'assets/snow_day.json';
        }
      case >= 700 && < 800:
        if (isNight) {
          path = 'assets/atmosphere.json';
        } else {
          path = 'assets/atmosphere_day.json';
        }
      case == 800:
        if (isNight) {
          path = 'assets/clear_night.json';
        } else {
          path = 'assets/clear_day.json';
        }
      case > 800 && <= 804:
        if (isNight) {
          path = 'assets/clouds_night.json';
        } else {
          path = 'assets/clouds_day.json';
        }
      default:
        path = 'assets/day&night.json';
    }
    return Lottie.asset(path);
  }
}
