import 'dart:developer';

import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_app/bloc/weather_bloc.dart';
import 'package:flutter_weather_app/screens/next_days_weather.dart';
import 'package:flutter_weather_app/widgets/weather_more_info_card.dart';

class HomeScreenContainer extends StatelessWidget {
  const HomeScreenContainer({
    super.key,
    required this.time,
    required this.weatherImage,
    required this.weatherMain,
    required this.state,
  });

  final DateTime time;
  final String weatherImage;
  final String weatherMain;
  final WeatherLoadedState state;

  String showNow(int index) {
    final DateTime now = DateTime.now();
    final DateTime forecastTime = state.hoursWeather!.list![index].dtTxt!;

    if (now.day == forecastTime.day &&
        now.hour <= forecastTime.hour &&
        forecastTime.hour - now.hour <= 3) {
      return 'Now';
    }
    return forecastTime.hour.toString();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final currentDayForecasts = state.hoursWeather?.list!
        .where((forecast) =>forecast.dtTxt != null && forecast.dtTxt!.day == now.day)
        .toList();
    

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
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: Row(
                  children: [
                    const Text(
                      'Today',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff303345),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NextDaysWeather(
                                state: state,
                              ),
                            ),
                          );
                        },
                        child: const Text('Next 3 days')),
                  ],
                ),
              ),

              // Прогноз на несколько часов(карточки)
              if (state.hoursWeather != null && currentDayForecasts!.isNotEmpty)
                SizedBox(
                  height: 142,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: currentDayForecasts
                        .length, //state.hoursWeather!.list!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          //height: 120,
                          width: 70,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 163, 163),
                            borderRadius: BorderRadius.circular(40),
                            border: showNow(index) == 'Now'
                                ? Border.all(color: Colors.pink, width: 2)
                                : null,
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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 11,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          showNow(index),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: showNow(index) == 'Now'
                                                ? Colors.red
                                                : Color(0xff303345),
                                          ),
                                        ),
                                        if (showNow(index) != 'Now')
                                          Text(
                                            ':${state.hoursWeather!.list![index].dtTxt!.minute}0',
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
