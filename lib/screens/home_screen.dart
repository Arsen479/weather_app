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
  late WeatherBloc weatherHourlyBloc;
  late TextEditingController cityController;
  bool showSearchField = false;
  List<String> cityHistory = [];

  @override
  void initState() {
    weatherBloc = WeatherBloc();
    weatherHourlyBloc = WeatherBloc();
    cityController = TextEditingController();
    getCachedCurrentWeather();
    weatherHourlyBloc.add(GetHourlyWeather());
    loadCityHistory();
    super.initState();
  }

  @override
  void dispose() {
    weatherBloc.close();
    weatherHourlyBloc.close();
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

  Future<void> loadCityHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      cityHistory = prefs.getStringList('cityHistory') ?? [];
    });
  }

  Future<void> saveCityHistory(String city) async {
    if (!cityHistory.contains(city)) {
      cityHistory.add(city);
      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList('cityHistory', cityHistory);
    }
  }

  Future<void> removeCityFromHistory(String city) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cityHistory = prefs.getStringList('cityHistory') ?? [];

    cityHistory.remove(city);
    await prefs.setStringList('cityHistory', cityHistory);
    setState(() {
      this.cityHistory = cityHistory;
    });
  }

  void showCityHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('City History'),
          content: SizedBox(
            width: 500,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: cityHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(cityHistory[index]),
                  trailing: IconButton(
                    onPressed: () async {
                      await removeCityFromHistory(cityHistory[index]);
                      Navigator.pop(context);
                      showCityHistoryDialog();
                    },
                    icon: const Icon(Icons.delete_forever),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    weatherBloc.add(GetWeatherByCity(cityHistory[index]));
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime time = DateTime.now();

    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        title: Stack(
          children: [
            AnimatedOpacity(
              opacity: showSearchField ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: showSearchField
                    ? MediaQuery.of(context).size.width * 0.8
                    : 0,
                child: TextField(
                  controller: cityController,
                  decoration: InputDecoration(
                    hintText: 'Enter city name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 50),
                  ),
                  onSubmitted: (value) {
                    saveCityHistory(value);
                    weatherBloc.add(GetWeatherByCity(cityController.text));
                    cityController.clear();
                    setState(() {
                      showSearchField = false;
                    });
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    showSearchField = !showSearchField;
                  });
                },
                icon: Image.asset(
                  'assets/iconsearch.png',
                  height: 30,
                  width: 30,
                ),
                color: const Color(0xff313341),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 11),
            child: IconButton(
              icon: Image.asset('assets/Vector.png', height: 30, width: 30),
              onPressed: () {
                showCityHistoryDialog();
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            weatherBloc.add(GetCurrentWeather());
          },
          child: BlocBuilder<WeatherBloc, WeatherState>(
            bloc: weatherBloc,
            builder: (context, state) {
              if (state is WeatherLoadedState) {
                final weatherMain = state.weather.weather![0].main;
                final weatherImage = getWeatherImage(weatherMain!);

                return HomeScreenContainer(
                  //weatherBloc: weatherBloc,
                  time: time,
                  weatherImage: weatherImage,
                  weatherMain: weatherMain,
                  state: state,
                  //weatherHourlyBloc: weatherHourlyBloc,
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
      ),
    );
  }
}
