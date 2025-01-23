import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_app/bloc/weather_bloc.dart';
import 'package:flutter_weather_app/widgets/weather_more_info_card.dart';

class HomeScreenContainer extends StatelessWidget {
  const HomeScreenContainer({
    super.key,
    //required this.weatherBloc,
    required this.time,
    required this.weatherImage,
    required this.weatherMain,
    required this.state,
    //required this.weatherHourlyBloc,
  });

  //final WeatherBloc weatherBloc;
  //final WeatherBloc weatherHourlyBloc;
  final DateTime time;
  final String weatherImage;
  final String weatherMain;
  final WeatherLoadedState state;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: 1,
      itemBuilder: (context, index) {
        return Container(
          height: 800, //MediaQuery.of(context).size.height,
          width: 300, //MediaQuery.of(context).size.width,
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
                        const SizedBox(width: 20),
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
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: Text(
                  'Today',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff303345),
                  ),
                ),
              ),

              // Прогноз на несколько часов
              if (state.hoursWeather != null)
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.hoursWeather!.list!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 100,
                          width: 70,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 163, 163),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    '${state.hoursWeather!.list![index].main!.temp}°C',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff303345),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 11),
                                    child: Row(
                                      children: [
                                        Text(
                                          '${state.hoursWeather!.list![index].dtTxt!.hour}:',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff303345),
                                          ),
                                        ),
                                        Text(
                                          '${state.hoursWeather!.list![index].dtTxt!.minute}0',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff303345),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Image.network(
                                    'https://openweathermap.org/img/wn/${state.hoursWeather!.list![index].weather![0].icon}@2x.png',
                                    height: 50,
                                    width: 50,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.error,
                                          color: Colors.red);
                                    },
                                  ),
                                  Text(
                                    '${state.hoursWeather!.list![index].weather![0].main}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff303345),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
