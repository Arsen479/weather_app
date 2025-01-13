import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_weather_app/helpers/api_requester.dart';
import 'package:flutter_weather_app/models/cuerrent_weather_model.dart';
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
        final data = jsonDecode(response.body);

        log('Current weather: $data');

        prefs.setString('weather', jsonEncode(data));
        prefs.setString('selected_city', cachedCity);

        emit(WeatherLoadedState(Weather.fromJson(data)));
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

          emit(WeatherLoadedState(Weather.fromJson(data)));
        }

        final prefs = await SharedPreferences.getInstance();
        final cachedCity = prefs.getString('selected_city') ?? 'Bishkek';

        final response = await ApiRequester().getResponse(cachedCity);
        final data = jsonDecode(response.body);

        prefs.setString('weather', jsonEncode(data));
        prefs.setString('selected_city', cachedCity);

        log('Refreshed data: $data');

        emit(WeatherLoadedState(Weather.fromJson(data)));
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

        emit(WeatherLoadedState(Weather.fromJson(data)));
      } catch (error) {
        emit(WeatherErrorState(error.toString()));
      }
    });
  }
}
