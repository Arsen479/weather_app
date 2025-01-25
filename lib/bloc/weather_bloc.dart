import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
//import 'package:flutter_weather_app/helpers/api_requester.dart';
import 'package:flutter_weather_app/models/cuerrent_weather_model.dart'
    as current;
import 'package:flutter_weather_app/models/hours_weather_model.dart' as hourly;
import 'package:flutter_weather_app/repository/repository.dart';
//import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    Repository repository = Repository();

    on<GetCurrentWeather>((event, emit) async {
      try {
        emit(WeatherLoadingState());

        final prefs = await SharedPreferences.getInstance();
        final cachedCity = prefs.getString('selected_city') ?? 'Bishkek';

        current.Weather weatherModel = await repository.getWeather(cachedCity);

        hourly.WeatherThreeHours hourlyModel =
            await repository.getHourlyWeather(cachedCity);

        log('Current weather: $weatherModel');
        log('Current hourly weather: $hourlyModel');

        prefs.setString('weather', jsonEncode(weatherModel));
        prefs.setString('selected_city', cachedCity);

        emit(
          WeatherLoadedState(weather: weatherModel, hoursWeather: hourlyModel),
        );
      } catch (error) {
        emit(WeatherErrorState(error.toString()));
      }
    });

    on<GetCachedCurrentWeather>((event, emit) async {
      try {
        emit(WeatherLoadingState());

        if (event.weatherData != null) {
          final data = jsonDecode(event.weatherData!);
          log('Cached weather data: $data');

          emit(WeatherLoadedState(weather: current.Weather.fromJson(data)));
        }

        final prefs = await SharedPreferences.getInstance();
        final cachedCity = prefs.getString('selected_city') ?? 'Bishkek';

        current.Weather weatherModel = await repository.getWeather(cachedCity);
        hourly.WeatherThreeHours hourlyModel =
            await repository.getHourlyWeather(cachedCity);

        prefs.setString('weather', jsonEncode(weatherModel));
        prefs.setString('selected_city', cachedCity);

        log('Refreshed data: $weatherModel');

        emit(
          WeatherLoadedState(weather: weatherModel, hoursWeather: hourlyModel),
        );
      } catch (error) {
        log(error.toString());
        emit(WeatherErrorState(error.toString()));
      }
    });

    on<GetWeatherByCity>((event, emit) async {
      try {
        emit(WeatherLoadingState());

        current.Weather weatherModel = await repository.getWeather(event.city);
        hourly.WeatherThreeHours hourlyModel =
            await repository.getHourlyWeather(event.city);

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('weather', jsonEncode(weatherModel));
        prefs.setString('selected_city', event.city);

        log('City weather for:${event.city}: $weatherModel');
        log('City weather for:${event.city}: $hourlyModel');

        emit(
          WeatherLoadedState(weather: weatherModel, hoursWeather: hourlyModel),
        );
      } catch (error) {
        emit(WeatherErrorState(error.toString()));
      }
    });

    on<GetHourlyWeather>((event, emit) async {
      try {
        emit(WeatherLoadingState());

        final prefs = await SharedPreferences.getInstance();
        final cachedCity = prefs.getString('selected_city') ?? 'Bishkek';

        current.Weather weatherModel = await repository.getWeather(cachedCity);
        hourly.WeatherThreeHours hourlyModel =
            await repository.getHourlyWeather(cachedCity);

        log('Hourly weather: $hourlyModel');

        emit(
          WeatherLoadedState(weather: weatherModel, hoursWeather: hourlyModel),
        );
      } catch (error) {
        emit(WeatherErrorState(error.toString()));
      }
    });
  }
}
