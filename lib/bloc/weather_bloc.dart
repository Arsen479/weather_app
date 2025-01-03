import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_weather_app/helpers/api_requester.dart';
import 'package:flutter_weather_app/models/cuerrent_weather_model.dart';
import 'package:meta/meta.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    on<GetCurrentWeather>((event, emit) async {
      try {
        emit(WeatherLoadingState());

        final response = await ApiRequester().getResponse('Bishkek');
        //final data = jsonDecode(response.body);
        final Map<String, dynamic> data = jsonDecode(response.body);

        log('$data');

        emit(WeatherLoadedState(Weather.fromJson(data)));
      } catch (error) {
        emit(WeatherErrorState(error.toString()));
      }
    });
  }
}
