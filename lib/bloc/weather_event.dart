part of 'weather_bloc.dart';

@immutable
sealed class WeatherEvent {}

final class GetCurrentWeather extends WeatherEvent {
  
}
final class GetCachedCurrentWeather extends WeatherEvent {
  final String? weatherData;

  GetCachedCurrentWeather(this.weatherData);
}
