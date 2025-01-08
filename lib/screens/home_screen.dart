import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_app/bloc/weather_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late WeatherBloc weatherBloc;
  late TextEditingController cityController;

  @override
  void initState() {
    weatherBloc = WeatherBloc();
    cityController = TextEditingController();
    getCachedCurrentWeather();
    super.initState();
  }

  @override
  void dispose() {
    weatherBloc.close();
    cityController.dispose();
    super.dispose();
  }

  Future<void> getCachedCurrentWeather() async {
    final prefs = await SharedPreferences.getInstance();
    String? weather = prefs.getString('weather');
    // if (weather != null) {
    // weatherBloc.add(GetCachedCurrentWeather(weather));
    // } else {
    weatherBloc.add(GetCurrentWeather());
    // }
  }

  String getWeatherImage(String main) {
    if (main.contains('Clouds')) {
      return 'assets/iconcloud.png';
    } else if (main.contains('Rain')) {
      return 'assets/iconrainy.png';
    } else if (main.contains('Clear')) {
      return 'assets/iconsuny.png';
    } else if (main.contains('Snow')) {
      return 'assets/free-icon-snow-4724105.png';
    } else {
      return 'assets/iconsuny.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime time = DateTime.now();

    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: SafeArea(
        child: BlocBuilder<WeatherBloc, WeatherState>(
          bloc: weatherBloc,
          builder: (context, state) {
            if (state is WeatherLoadedState) {
              final weatherMain = state.weather.weather[0].main;
              final weatherImage = getWeatherImage(weatherMain);

              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.95,
                width: MediaQuery.of(context).size.width * 1,
                child: Container(
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
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return TextField(
                                      controller: cityController,
                                      onSubmitted: (value) {
                                        weatherBloc.add(
                                          GetWeatherByCity(cityController.text),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.search),
                              iconSize: 40,
                              color: Color(0xff313341),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.format_list_bulleted_sharp,
                              size: 40,
                              color: Color(0xff313341),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${state.weather.sys.country},\n${state.weather.name}',
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
                                Image.asset(weatherImage,
                                    height: 100, width: 100),
                                SizedBox(width: 20),
                                Column(
                                  children: [
                                    Text(
                                      '${state.weather.main.temp.toString()}°C',
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
                                    // Padding(
                                    //   padding: const EdgeInsets.all(10.0),
                                    //   child: Column(
                                    //     children: [
                                    //       weatherMoreInfo(
                                    //           iconPath: 'assets/iconwind.png',
                                    //           title: 'Wind',
                                    //           value:
                                    //               '${state.weather.wind.speed} m/sec'),
                                    //     ],
                                    //   ),
                                    // )
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  weatherMoreInfo(
                                      iconPath: 'assets/iconwind.png',
                                      title: 'Wind',
                                      value:
                                          '${state.weather.wind.speed} m/sec'),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      //Text('Clouds: ${state.weather.weather[0].description}'),
                      //Text('Humidity: ${state.weather.main.humidity}%'),
                      //Text('Wind: ${state.weather.wind.speed} m/sec'),
                      //Text('Humidity: ${state.weather.dt}'),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     weatherBloc.add(GetCurrentWeather());
                      //   },
                      //   child: Text('Get weather'),
                      // ),
                    ],
                  ),
                ),
              );
            } else if (state is WeatherLoadingState) {
              return CircularProgressIndicator();
            } else if (state is WeatherErrorState) {
              return Text(state.error);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class WeatheroInfo extends StatelessWidget {
  const WeatheroInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

Widget weatherMoreInfo({
  required String iconPath,
  required String title,
  required String value,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 300,
          height: 50,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 163, 163),
            borderRadius: BorderRadius.circular(20),
          ),
        )
        // Image.asset(iconPath, height: 40, width: 40),
        // const SizedBox(width: 16),
        // Expanded(
        //   child: Text(
        //     title,
        //     style: const TextStyle(
        //       fontSize: 20,
        //       fontWeight: FontWeight.w500,
        //       color: Color(0xff303345),
        //     ),
        //   ),
        // ),
        // Text(
        //   value,
        //   style: const TextStyle(
        //     fontSize: 20,
        //     fontWeight: FontWeight.w400,
        //     color: Color(0xff303345),
        //   ),
        // ),
      ],
    ),
  );
}
