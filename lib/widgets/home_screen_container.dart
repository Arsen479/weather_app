import 'package:flutter/material.dart';
import 'package:flutter_weather_app/bloc/weather_bloc.dart';
import 'package:flutter_weather_app/widgets/weather_more_info_card.dart';

class HomeScreenContainer extends StatelessWidget {
  const HomeScreenContainer({
    super.key,
    required this.weatherBloc,
    required this.time,
    required this.weatherImage,
    required this.weatherMain,
    required this.state,
  });

  final WeatherBloc weatherBloc;
  final DateTime time;
  final String weatherImage;
  final String weatherMain;
  final WeatherLoadedState state;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        weatherBloc.add(GetCurrentWeather());
      },
      child: SingleChildScrollView(
        //physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.white54,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 255, 158, 180),
                Color.fromARGB(255, 255, 127, 157),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${state.weather.sys!.country},\n${state.weather.name}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff313341),
                      ),
                    ),
                    Text(
                      '${time.day}/${time.month}/${time.year}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff9A938C),
                      ),
                    ),
                    Row(
                      children: [
                        Image.asset(weatherImage, height: 100, width: 100),
                        SizedBox(width: 20),
                        Column(
                          children: [
                            Text(
                              '${state.weather.main!.temp.toString()}°C',
                              style: const TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff303345),
                              ),
                            ),
                            Text(
                              '$weatherMain',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff303345),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              WeatherInfo(
                  iconPath: 'assets/iconwind2.png',
                  title: 'Wind',
                  value: '${state.weather.wind!.speed} m/sec'),
              WeatherInfo(
                  iconPath: 'assets/iconhumidity2.png',
                  title: 'Humidity',
                  value: '${state.weather.main!.humidity}%'),
              WeatherInfo(
                  iconPath: '$weatherImage',
                  title: '${state.weather.weather![0].main}',
                  value: '${state.weather.clouds!.all}%'),
            ],
          ),
        ),
      ),
    );
  }
}
