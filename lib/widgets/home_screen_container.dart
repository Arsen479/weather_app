// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_weather_app/bloc/weather_bloc.dart';
// import 'package:flutter_weather_app/widgets/weather_more_info_card.dart';

// class HomeScreenContainer extends StatelessWidget {
//   const HomeScreenContainer({
//     super.key,
//     required this.weatherBloc,
//     required this.time,
//     required this.weatherImage,
//     required this.weatherMain,
//     required this.state,
//   });

//   final WeatherBloc weatherBloc;
//   final DateTime time;
//   final String weatherImage;
//   final String weatherMain;
//   final WeatherLoadedState state;

//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: () async {
//         weatherBloc.add(GetCurrentWeather());
//       },
//       child: SingleChildScrollView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         child: Container(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           decoration: const BoxDecoration(
//             color: Colors.white54,
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Color.fromARGB(255, 255, 158, 180),
//                 Color.fromARGB(255, 255, 127, 157),
//               ],
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       '${state.weather.sys!.country},\n${state.weather.name}',
//                       style: const TextStyle(
//                         fontSize: 32,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xff313341),
//                       ),
//                     ),
//                     Text(
//                       '${time.day}/${time.month}/${time.year}',
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xff9A938C),
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         Image.asset(weatherImage, height: 100, width: 100),
//                         SizedBox(width: 20),
//                         Column(
//                           children: [
//                             Text(
//                               '${state.weather.main!.temp.toString()}°C',
//                               style: const TextStyle(
//                                 fontSize: 50,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xff303345),
//                               ),
//                             ),
//                             Text(
//                               '$weatherMain',
//                               style: const TextStyle(
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.w500,
//                                 color: Color(0xff303345),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               WeatherInfo(
//                   iconPath: 'assets/iconwind2.png',
//                   title: 'Wind',
//                   value: '${state.weather.wind!.speed} m/sec'),
//               WeatherInfo(
//                   iconPath: 'assets/iconhumidity2.png',
//                   title: 'Humidity',
//                   value: '${state.weather.main!.humidity}%'),
//               WeatherInfo(
//                   iconPath: '$weatherImage',
//                   title: '${state.weather.weather![0].main}',
//                   value: '${state.weather.clouds!.all}%'),
//               const Padding(
//                 padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
//                 child: Text(
//                   'Today',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xff303345),
//                   ),
//                 ),
//               ),
//               //блок для вывода погоды на несколько часов
//               Expanded(
//                 flex: 2,
//                 child: BlocBuilder<WeatherBloc, WeatherState>(
//                   bloc: weatherBloc,
//                   builder: (context, state) {
//                     if (state is WeatherLoadedState) {
//                       return SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         physics: const AlwaysScrollableScrollPhysics(),
//                         child: Row(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Container(
//                                 height: 200,
//                                 width: 70,
//                                 decoration: BoxDecoration(
//                                   color: const Color.fromARGB(
//                                       255, 255, 163, 163),
//                                   borderRadius: BorderRadius.circular(40),
//                                 ),
//                                 child: Text(
//                                   '${state.weather.main!.temp}',
//                                   style: const TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color(0xff303345),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }
//                     return SizedBox();
//                   },
//                 ),
//               )
//               //карты для отображения погоды с горизонтальной прокруткой
//               // Expanded(
//               //   child: SingleChildScrollView(
//               //     scrollDirection: Axis.horizontal,
//               //     physics: const AlwaysScrollableScrollPhysics(),
//               //     child: SizedBox(
//               //       height: 100,
//               //       child: Row(
//               //         children: [
//               //           Padding(
//               //             padding: const EdgeInsets.all(8.0),
//               //             child: Container(
//               //               height: 100,
//               //               width: 70,
//               //               decoration: BoxDecoration(
//               //                 color: const Color.fromARGB(255, 255, 163, 163),
//               //                 borderRadius: BorderRadius.circular(40),
//               //               ),
//               //               child: Column(
//               //                 children: [
//               //                   // Image.asset(weatherImage,
//               //                   //     height: 100, width: 100),
//               //                   Text(
//               //                     '${state.weather.main!.temp}',
//               //                     style: const TextStyle(
//               //                       fontSize: 12,
//               //                       fontWeight: FontWeight.bold,
//               //                       color: Color(0xff303345),
//               //                     ),
//               //                   ),
//               //                 ],
//               //               ),
//               //             ),
//               //           ),
//               //         ],
//               //       ),
//               //     ),
//               //   ),
//               // )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    required this.weatherHourlyBloc,
  });

  final WeatherBloc weatherBloc;
  final WeatherBloc weatherHourlyBloc;
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
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount:
            1, // Так как основной контент — фиксированный, создаем 1 "раздел".
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
                SizedBox(
                  height: 140, // Высота блока с горизонтальной прокруткой
                  child: BlocBuilder<WeatherBloc, WeatherState>(
                    bloc: weatherBloc,
                    builder: (context, state) {
                      if (state is WeatherLoadedState) {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10, // Количество элементов прогноза
                          itemBuilder: (context, index) {
                            if (state.hoursWeather != null) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  height: 100,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 255, 163, 163),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${state.hoursWeather!.list![index].main!.temp}°C',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff303345),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }else{
                              print('ошибка нет данных');
                            }
                            return const SizedBox();
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
