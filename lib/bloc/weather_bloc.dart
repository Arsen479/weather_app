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

        final response = await ApiRequester().getResponse('Bishkek');
        final data = jsonDecode(response.body);

        log('$data');

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('weather', jsonEncode(data));

        emit(WeatherLoadedState(Weather.fromJson(data)));
      } catch (error) {
        emit(WeatherErrorState(error.toString()));
      }
    });

    on<GetCachedCurrentWeather>((event, emit) async {
      try {
        emit(WeatherLoadingState());

        //final String CachedweatherData = event.weatherData!;
        final prefs = await SharedPreferences.getInstance();
        final String? haveDataWeather = prefs.getString('weather');
        if (haveDataWeather != null) {
          final data = jsonDecode(haveDataWeather);
          log('$data');

          

          emit(WeatherLoadedState(Weather.fromJson(data)));
        }

        final respons  = await ApiRequester().getResponse('Bishkek');
        //final data = jsonDecode(event.weatherData!);

        

        //emit(WeatherLoadedState(Weather.fromJson(data)));
      } catch (error) {
        emit(WeatherErrorState(error.toString()));
      }
    });

    on<GetWeatherByCity>((event, emit) async {
      try {
        emit(WeatherLoadingState());

        final response =  await ApiRequester().getResponse(event.city);
        final data = jsonDecode(response.body);


        log('$data');

        emit(WeatherLoadedState(Weather.fromJson(data)));
      } catch (error) {
        emit(WeatherErrorState(error.toString()));
      }
    });
  }
}
