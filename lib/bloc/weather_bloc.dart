import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_weather_app/helpers/api_requester.dart';
import 'package:flutter_weather_app/models/cuerrent_weather_model.dart'
    as current;
import 'package:flutter_weather_app/models/hours_weather_model.dart' as hourly;
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    on<GetCurrentWeather>((event, emit) async {
      try {
        emit(WeatherLoadingState());

        final prefs = await SharedPreferences.getInstance();
        final cachedCity = prefs.getString('selected_city') ?? 'Bishkek';

        final response = await ApiRequester().getResponse(cachedCity);
        final response2 = await ApiRequester().getHourlyResponse(cachedCity);
        final data = jsonDecode(response.body);
        final hourlyData = jsonDecode(response2.body);

        log('Current weather: $data');
        log('Current hourly weather: $hourlyData');

        prefs.setString('weather', jsonEncode(data));
        prefs.setString('selected_city', cachedCity);

        emit(WeatherLoadedState(
            weather: current.Weather.fromJson(data),
            hoursWeather: hourly.WeatherThreeHours.fromJson(hourlyData)));
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

        final response = await ApiRequester().getResponse(cachedCity);
        final data = jsonDecode(response.body);

        prefs.setString('weather', jsonEncode(data));
        prefs.setString('selected_city', cachedCity);

        log('Refreshed data: $data');

        emit(WeatherLoadedState(weather: current.Weather.fromJson(data)));
      } catch (error) {
        log(error.toString());
        emit(WeatherErrorState(error.toString()));
      }
    });

    on<GetWeatherByCity>((event, emit) async {
      try {
        emit(WeatherLoadingState());

        final response = await ApiRequester().getResponse(event.city);
        final data = jsonDecode(response.body);

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('weather', jsonEncode(data));
        prefs.setString('selected_city', event.city);

        log('City weather for:${event.city}: $data');

        emit(WeatherLoadedState(weather: current.Weather.fromJson(data)));
      } catch (error) {
        emit(WeatherErrorState(error.toString()));
      }
    });

    on<GetHourlyWeather>((event, emit) async {
      try {
        emit(WeatherLoadingState());

        final prefs = await SharedPreferences.getInstance();
        final cachedCity = prefs.getString('selected_city') ?? 'Bishkek';

        final response = await ApiRequester().getHourlyResponse(cachedCity);
        final response2 = await ApiRequester().getResponse(cachedCity);
        final hourlyWeather = jsonDecode(response.body);
        final currentWeather = jsonDecode(response2.body);

        log('Hourly weather: $hourlyWeather');

        emit(WeatherLoadedState( weather: current.Weather.fromJson(currentWeather),
            hoursWeather: hourly.WeatherThreeHours.fromJson(hourlyWeather)));
      } catch (error) {
        emit(WeatherErrorState(error.toString()));
      }
    });
  }
}
