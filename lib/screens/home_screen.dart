import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_app/bloc/weather_bloc.dart';
import 'package:flutter_weather_app/widgets/home_screen_container.dart';
import 'package:flutter_weather_app/widgets/weather_more_info_card.dart';
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
    if (weather != null) {
      weatherBloc.add(GetCachedCurrentWeather(weather));
    } else {
      weatherBloc.add(GetCurrentWeather());
    }
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
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        leading: IconButton(
          onPressed: () {
            showModalBottomSheet(
              backgroundColor: Color.fromARGB(255, 255, 202, 215),
              showDragHandle: true,
              useSafeArea: true,
              constraints: const BoxConstraints(
                maxHeight: 800,
                minHeight: 500,
              ),
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return TextField(
                  controller: cityController,
                  decoration: InputDecoration(
                    hintText: 'Enter city name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onSubmitted: (value) {
                    weatherBloc.add(
                      GetWeatherByCity(cityController.text),
                    );
                    cityController.clear();
                  },
                );
              },
            );
          },
          icon: Image.asset('assets/iconsearch.png', height: 30, width: 30),
          iconSize: 40,
          color: Color(0xff313341),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 11),
            child: Image.asset('assets/Vector.png', height: 30, width: 30),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<WeatherBloc, WeatherState>(
          bloc: weatherBloc,
          builder: (context, state) {
            if (state is WeatherLoadedState) {
              final weatherMain = state.weather.weather![0].main;
              final weatherImage = getWeatherImage(weatherMain!);

              return HomeScreenContainer(
                weatherBloc: weatherBloc,
                time: time,
                weatherImage: weatherImage,
                weatherMain: weatherMain,
                state: state,
              );
            } else if (state is WeatherLoadingState) {
              return Center(
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
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Loading...',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff313341),
                        ),
                      ),
                      SizedBox(height: 20),
                      CircularProgressIndicator(
                        backgroundColor: Colors.pink,
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is WeatherErrorState) {
              return Container(
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
                child: const Center(
                  child: Text(
                    'City not found try again',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff313341),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
