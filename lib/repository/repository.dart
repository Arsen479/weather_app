import 'dart:convert';

import 'package:flutter_weather_app/helpers/api_requester.dart';
import 'package:flutter_weather_app/models/cuerrent_weather_model.dart'
    as current;
import 'package:flutter_weather_app/models/hours_weather_model.dart' as hourly;

class Repository {
  static String apiKey = 'b9492f011176869c0b9b21dbfd3dde9a';
  ApiRequester apiRequester = ApiRequester();

  Future<current.Weather> getWeather(String city) async {
    final response = await apiRequester.getResponse2(
        '/weather', {'q': city, 'appid': apiKey, 'units': 'metric'});

    final data = jsonDecode(response.body);

    return current.Weather.fromJson(data);
  }

  Future<hourly.WeatherThreeHours> getHourlyWeather(String city) async {
    final response = await ApiRequester().getResponse2(
        '/forecast', {'q': city, 'appid': apiKey, 'units': 'metric'});

    final data = jsonDecode(response.body);

    return hourly.WeatherThreeHours.fromJson(data);
  }
}
