part of 'weather_bloc.dart';

@immutable
sealed class WeatherEvent {}

final class GetCurrentWeather extends WeatherEvent {
  
}
final class GetCachedCurrentWeather extends WeatherEvent {
  final String? weatherData;

  GetCachedCurrentWeather(this.weatherData);
}

final class GetWeatherByCity extends WeatherEvent {
  final String city;

  GetWeatherByCity(this.city);
}

final class GetHourlyWeather extends WeatherEvent{}
