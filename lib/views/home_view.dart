import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/cubites/get_weather_cubits/get_weather_cubits.dart';
import 'package:weatherapp/cubites/get_weather_cubits/get_weather_states.dart';
import 'package:weatherapp/cubites/llm_weather_dersciption/llm_weather_cubit.dart';
import 'package:weatherapp/widgets/no_weather_body.dart';
import 'package:weatherapp/widgets/weather_info_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App')),
      body: BlocBuilder<GetWeatherCubit, WeatherState>(
        builder: ((context, state) {
          final isweatherloaded = state is WeatherLoadedState;
          return PopScope(
            canPop: !isweatherloaded,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;
              if (isweatherloaded) {
                context.read<GetWeatherCubit>().resetState();
              }
            },
            child:
                isweatherloaded
                    ? WeatherInfoBody(
                      weather: state.weatherModel,
                      llmWeatherCubit: context.read<LlmWeatherCubit>(),
                    )
                    : NoWeatherBody(),
          );
        }),
      ),
    );
  }
}
