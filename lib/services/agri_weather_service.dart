import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/agri_weather.dart';

class AgriWeatherService {
  final String apiKey;

  AgriWeatherService({required this.apiKey});

  Future<AgriWeather> fetchAgriWeather(double lat, double lon) async {
    final baseUrl = 'https://api.weatherbit.io/v2.0/agweather/forecast/daily';
    final url = '$baseUrl?key=$apiKey&lat=$lat&lon=$lon';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final agriWeatherData = jsonData['data'][0]; // Assuming first day data
      return AgriWeather.fromJson(agriWeatherData);
    } else {
      throw Exception('Failed to load agricultural weather data');
    }
  }
}
