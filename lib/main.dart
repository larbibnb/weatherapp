import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/cubites/get_weather_cubits/get_weather_cubits.dart';
import 'package:weatherapp/cubites/get_weather_cubits/get_weather_states.dart';
import 'package:weatherapp/cubites/llm_weather_dersciption/llm_weather_cubit.dart';
import 'package:weatherapp/views/home_view.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LlmWeatherCubit()),
        BlocProvider(create: (context) => GetWeatherCubit()),
      ],
      child: Builder(
        builder:
            (context) => BlocBuilder<GetWeatherCubit, WeatherState>(
              builder: (context, state) {
                final weatherCubit = context.read<GetWeatherCubit>();
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: const HomeView(),
                  theme: ThemeData(
                    appBarTheme: AppBarTheme(
                      color:
                          state is WeatherLoadedState
                              ? getThemeColor(
                                weatherCubit.weatherModel.weatherStateName,
                              )
                              : Colors.blue,
                    ),
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: Colors.deepPurple,
                      secondary: Colors.yellow,
                    ),
                  ),
                );
              },
            ),
      ),
    );
  }
}

MaterialColor getThemeColor(String? condition) {
  if (condition == null) {
    return Colors.brown;
  }
  switch (condition.toLowerCase()) {
    case 'sunny':
      return Colors.amber;
    case 'partly cloudy':
    case 'cloudy':
      return Colors.grey;
    case 'overcast':
      return Colors.blueGrey;
    case 'mist':
      return Colors.lightBlue;
    case 'patchy rain possible':
    case 'thundery outbreaks possible':
      return Colors.blue;
    case 'patchy snow possible':
    case 'blowing snow':
    case 'blizzard':
    case 'patchy light snow':
    case 'light snow':
    case 'patchy moderate snow':
    case 'moderate snow':
    case 'patchy heavy snow':
    case 'heavy snow':
    case 'patchy light snow with thunder':
    case 'moderate or heavy snow with thunder':
      return Colors.red;
    case 'patchy sleet possible':
    case 'patchy freezing drizzle possible':
    case 'freezing fog':
    case 'patchy light drizzle':
    case 'light drizzle':
    case 'light freezing drizzle':
    case 'heavy freezing drizzle':
    case 'light rain':
    case 'moderate rain at times':
    case 'moderate rain':
    case 'heavy rain at times':
    case 'heavy rain':
    case 'light freezing rain':
    case 'moderate or heavy freezing rain':
    case 'light sleet':
    case 'moderate or heavy sleet':
    case 'light sleet showers':
    case 'moderate or heavy sleet showers':
    case 'light rain shower':
    case 'moderate or heavy rain shower':
    case 'torrential rain shower':
    case 'light showers of ice pellets':
    case 'moderate or heavy showers of ice pellets':
    case 'patchy light rain with thunder':
    case 'moderate or heavy rain with thunder':
    case 'light snow showers':
    case 'moderate or heavy snow showers':
      return Colors.lime;
    case 'fog':
      return Colors.grey;
    case 'ice pellets':
      return Colors.blueGrey;
    default:
      return Colors.yellow;
  }
}
