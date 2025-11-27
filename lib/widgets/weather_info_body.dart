import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/cubites/get_weather_cubits/get_weather_cubits.dart';
import 'package:weatherapp/cubites/llm_weather_dersciption/llm_weather_cubit.dart';
import 'package:weatherapp/cubites/llm_weather_dersciption/llm_weather_states.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/main.dart';
import 'package:intl/intl.dart';

// Helper widget for displaying Max/Min temperatures with icons/labels
class TemperatureDetail extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const TemperatureDetail({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.white70),
        const SizedBox(width: 4),
        Text(
          '$label: $value°',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class WeatherInfoBody extends StatelessWidget {
  const WeatherInfoBody({
    super.key,
    required this.weather,
    required this.llmWeatherCubit,
  });
  final WeatherModel weather;
  final LlmWeatherCubit llmWeatherCubit;

  @override
  Widget build(BuildContext context) {
    WeatherModel weatherModel =
        BlocProvider.of<GetWeatherCubit>(context).weatherModel;

    // Use a defined date format
    String formattedDate = DateFormat(
      'EEEE, MMMM d, yyyy',
    ).format(weatherModel.date);
    String formattedTime = DateFormat('h:mm a').format(weatherModel.date);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          // Use colors based on weather state for thematic background
          colors: [
            getThemeColor(weatherModel.weatherStateName),
            getThemeColor(
              weatherModel.weatherStateName,
            )[700]!, // Darker shade at top
            getThemeColor(weatherModel.weatherStateName)[300]!,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:
              CrossAxisAlignment
                  .stretch, // Stretch children for better alignment
          children: [
            const Spacer(flex: 2),
            // City Name
            Text(
              weatherModel.cityName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 36,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            // Date and Time
            Text(
              formattedTime,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, color: Colors.white70),
            ),
            Text(
              formattedDate,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),

            const SizedBox(height: 48),

            // Weather Icon, Temperature, Max/Min
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Weather Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.network(
                    'https:${weatherModel.weatherstateIcon}',
                    fit: BoxFit.scaleDown,
                    width: 100,
                    height: 100,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    },
                  ),
                ),

                // Average Temperature
                Text(
                  '${weatherModel.avgtemp.toString()}°',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 64,
                    color: Colors.white,
                  ),
                ),

                // Max/Min Temperature Column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TemperatureDetail(
                      label: 'Max',
                      value: weatherModel.maxTemp.toString(),
                      icon: Icons.keyboard_arrow_up,
                    ),
                    const SizedBox(height: 8),
                    TemperatureDetail(
                      label: 'Min',
                      value: weatherModel.minTemp.toString(),
                      icon: Icons.keyboard_arrow_down,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 48),

            // Weather State Name
            Text(
              weatherModel.weatherStateName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.white,
              ),
            ),

            const Spacer(flex: 1),

            // LLM Description Section
            Text(
              'Weather Description:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 10),

            // Button to fetch LLM Description
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white.withOpacity(0.2),
              child: IconButton(
                onPressed: () {
                  llmWeatherCubit.getLlmWeather(weatherModel);
                },
                icon: const Icon(
                  Icons.format_quote_sharp,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 15),

            // LLM Description BlocBuilder
            BlocBuilder<LlmWeatherCubit, LlmWeatherStates>(
              builder: (context, state) {
                if (state is LlmWeatherSuccess) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(horizontal: 0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Text(
                      state.description,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        fontWeight: FontWeight.normal,
                        color: Colors.black87, // Dark text for light background
                      ),
                    ),
                  );
                } else if (state is LlmWeatherFailure) {
                  return Text(
                    'Failed to get description: ${state.errorMessage}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.redAccent),
                  );
                } else if (state is LlmWeatherLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),

            const Spacer(flex: 1),
            // Last Updated Time
            Text(
              'Last Updated: ${formattedTime}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.white54),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
