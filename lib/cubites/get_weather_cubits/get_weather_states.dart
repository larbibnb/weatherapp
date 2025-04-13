import 'package:weatherapp/models/weather_model.dart';

class WeatherState {}

class NoWeatherInfoStates extends WeatherState {}

class WeatherLoadedState extends WeatherState {
  final WeatherModel weatherModel;

  WeatherLoadedState({required this.weatherModel});
}

class WeatherFailureState extends WeatherState {}
