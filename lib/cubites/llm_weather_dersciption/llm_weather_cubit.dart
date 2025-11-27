import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/cubites/llm_weather_dersciption/llm_weather_states.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/services/llm_service.dart';

class LlmWeatherCubit extends Cubit<LlmWeatherStates> {
  LlmWeatherCubit() : super(LlmWeatherInitial());
  void getLlmWeather(WeatherModel weatherModel) async {
    final data = weatherModel.toJson();
    final prompt =
        'Based on this data: ${jsonEncode(data)}, write a weather report that is both informative and engaging for a general audience. The report should be a single paragraph, highlighting the key weather conditions in a creative and descriptive way';
    emit(LlmWeatherLoading());
    try {
      final llmResponse = await LlmService().generate(prompt);
      emit(LlmWeatherSuccess(description: llmResponse));
    } catch (e) {
      emit(LlmWeatherFailure(errorMessage: e.toString()));
    }
  }

  void resetState() {
    emit(LlmWeatherInitial());
  }
}
