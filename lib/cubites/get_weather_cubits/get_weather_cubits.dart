import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:weatherapp/cubites/get_weather_cubits/get_weather_states.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/services/weather_service.dart';

class GetWeatherCubit extends Cubit<WeatherState> {
  GetWeatherCubit() : super(NoWeatherInfoStates());
  late WeatherModel weatherModel;

  getWeather({required String cityName}) async {
    try {
      weatherModel = await WeatherService(Dio()).getForcast(cityName: cityName);
      emit(WeatherLoadedState(weatherModel: weatherModel));
    } catch (e) {
      emit(WeatherFailureState());
    }
  }

  void resetState() {
    emit(NoWeatherInfoStates());
  }
}
