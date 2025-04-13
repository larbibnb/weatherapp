import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:weatherapp/models/weather_model.dart';

class WeatherService {
  final String baseUrl = 'https://api.weatherapi.com/v1';
  final String apiKey = '3b485548825b4754aa332430242503';
  Dio dio;
  WeatherService(this.dio);
  Future<WeatherModel> getForcast({required String cityName}) async {
    try {
      Response response = await dio.get(
        '$baseUrl/forecast.json?key=$apiKey&q=$cityName&days=1',
      );

      WeatherModel weatherModel = WeatherModel.fromJson(response.data);
      return weatherModel;
    } on DioException catch (e) {
      final String mssgError =
          e.response?.data['error']['message'] ?? 'oops there was an error';
      throw Exception(mssgError);
    } catch (e) {
      log(e.toString());
      throw Exception('there was an error');
    }
  }
}
