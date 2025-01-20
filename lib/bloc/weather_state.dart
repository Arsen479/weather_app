part of 'weather_bloc.dart';

@immutable
sealed class WeatherState {}

final class WeatherInitial extends WeatherState {}

final class WeatherLoadingState extends WeatherState {}

final class WeatherLoadedState extends WeatherState {
  final current.Weather weather;
  final hourly.WeatherThreeHours? hoursWeather;

  WeatherLoadedState({required this.weather, this.hoursWeather});
}


final class WeatherThreeHoursForecastLoadedState extends WeatherState {
  final hourly.WeatherThreeHours weather;

  WeatherThreeHoursForecastLoadedState(this.weather);
}

final class WeatherErrorState extends WeatherState {
  final String error;

  WeatherErrorState(this.error);
}
