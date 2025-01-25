import 'package:flutter/material.dart';
import 'package:flutter_weather_app/bloc/weather_bloc.dart';

class NextDaysWeather extends StatefulWidget {
  final WeatherLoadedState state; // Передаем state из главного экрана

  const NextDaysWeather({super.key, required this.state});

  @override
  State<NextDaysWeather> createState() => _NextDaysWeatherState();
}

class _NextDaysWeatherState extends State<NextDaysWeather> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather for Next Days'),
        backgroundColor: Colors.pink[100],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 255, 158, 180),
              Color.fromARGB(255, 255, 127, 157),
            ],
          ),
        ),
        child: ListView.builder(
          itemCount: widget.state.hoursWeather!.list!.length,
          itemBuilder: (BuildContext context, int index) {
            final formattedDate =
                formatDate(widget.state.hoursWeather!.list![index].dtTxt!);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Text(
                      '${widget.state.hoursWeather!.list![index].dtTxt!.hour}:00',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${widget.state.hoursWeather!.list![index].main!.temp}°',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Image.network(
                          'https://openweathermap.org/img/wn/${widget.state.hoursWeather!.list![index].weather![0].icon}@2x.png',
                          height: 40,
                          width: 40,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error, color: Colors.red);
                          },
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String formatDate(DateTime dateTime) {
    return "${dateTime.year}-${(dateTime.month)}-${(dateTime.day)}";
  }
}
