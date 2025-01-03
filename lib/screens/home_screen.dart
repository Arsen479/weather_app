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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                weatherBloc.add(GetCurrentWeather());
              },
              child: Text('Get weather'),
            ),
            BlocBuilder<WeatherBloc, WeatherState>(
              bloc: weatherBloc,
              builder: (context, state) {
                if (state is WeatherLoadedState) {
                  return Container(
                    width: 200,
                    color: Colors.white54,
                    child: Column(
                      children: [
                        Text('Country: ${state.weather.sys.country}'),
                        Text('Name: ${state.weather.name}'),
                        Text(
                            'Temperature: ${state.weather.main.temp.toString()}°C'),
                      ],
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
