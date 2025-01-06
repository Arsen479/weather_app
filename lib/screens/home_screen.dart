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

  @override
  void initState() {
    weatherBloc = WeatherBloc();
    getCachedCurrentWeather();
    super.initState();
  }

  @override
  void dispose() {
    weatherBloc.close();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: SafeArea(
        child: Column(
          children: [
            BlocBuilder<WeatherBloc, WeatherState>(
              bloc: weatherBloc,
              builder: (context, state) {
                if (state is WeatherLoadedState) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.95,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Container(
                      //width: 200,
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
                        children: [
                          Text('Country: ${state.weather.sys.country}'),
                          Text('Name: ${state.weather.name}'),
                          Text(
                              'Temperature: ${state.weather.main.temp.toString()}°C'),
                          Text(
                              'Clouds: ${state.weather.weather[0].description}'),
                          Text('Humidity: ${state.weather.main.humidity}%'),
                          ElevatedButton(
                            onPressed: () {
                              weatherBloc.add(GetCurrentWeather());
                            },
                            child: Text('Get weather'),
                          ),
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
          ],
        ),
      ),
    );
  }
}
