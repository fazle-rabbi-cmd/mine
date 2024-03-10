import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mine/models/weather.dart';

class WeatherService {
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getCurrentWeather(double lat, double lon) async {
    final baseUrl = 'https://api.weatherbit.io/v2.0';
    final response = await http.get(
      Uri.parse('$baseUrl/current?lat=$lat&lon=$lon&key=$apiKey'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Weather.fromJson(data['data'][0]);
    } else {
      throw Exception('Failed to load current weather');
    }
  }

  Future<Weather> getWeatherByLocationName(String locationName) async {
    final baseUrl = 'https://api.weatherbit.io/v2.0';
    final response = await http.get(
      Uri.parse('$baseUrl/current?city=$locationName&key=$apiKey'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Weather.fromJson(data['data'][0]);
    } else {
      throw Exception('Failed to load weather for location: $locationName');
    }
  }

  Future<List<Weather>> getDailyForecast(double? lat, double? lon) async {
    if (lat == null || lon == null) {
      throw Exception('Latitude and longitude must not be null.');
    }
    final baseUrl = 'https://api.weatherbit.io/v2.0';
    final response = await http.get(
      Uri.parse('$baseUrl/forecast/daily?lat=$lat&lon=$lon&key=$apiKey'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final forecasts = data['data'] as List;
      return forecasts
          .map((forecast) => Weather.fromJson(forecast))
          .take(7)
          .toList();
    } else {
      throw Exception('Failed to load daily forecast');
    }
  }

  Future<List<Weather>> getHourlyForecast(double? lat, double? lon) async {
    if (lat == null || lon == null) {
      throw Exception('Latitude and longitude must not be null.');
    }
    final baseUrl = 'https://api.weatherbit.io/v2.0';
    final response = await http.get(
      Uri.parse('$baseUrl/forecast/hourly?lat=$lat&lon=$lon&key=$apiKey'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final forecasts = data['data'] as List;
      return forecasts
          .map((forecast) => Weather.fromJson(forecast))
          .take(24)
          .toList();
    } else {
      throw Exception('Failed to load hourly forecast');
    }
  }
}
