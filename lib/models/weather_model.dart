class WeatherModel {
  final String cityName;
  final DateTime date;
  final double avgtemp;
  final double minTemp;
  final double maxTemp;
  final String weatherStateName;
  final String? weatherstateIcon;

  WeatherModel(
      {required this.cityName,
      required this.date,
      required this.avgtemp,
      required this.minTemp,
      required this.maxTemp,
      required this.weatherStateName,
      this.weatherstateIcon});
  factory WeatherModel.fromJson(json) {
    return WeatherModel(
      cityName: json['location']['name'],
      date: DateTime.parse(json['current']['last_updated']),
      avgtemp: json['forecast']['forecastday'][0]['day']['avgtemp_c'],
      minTemp: json['forecast']['forecastday'][0]['day']['mintemp_c'],
      maxTemp: json['forecast']['forecastday'][0]['day']['maxtemp_c'],
      weatherStateName: json['forecast']['forecastday'][0]['day']['condition']
          ['text'],
      weatherstateIcon: json['forecast']['forecastday'][0]['day']['condition']
          ['icon'],
    );
  }
}
