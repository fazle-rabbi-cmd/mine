import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenMeteoService {
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';
  String _openWeatherApiKey = 'c0d1009550c934bb96a545c2d2f38878';

  OpenMeteoService(this._openWeatherApiKey);

  Future<String> getPastWeather(String locationName, DateTime date) async {
    try {
      final coordinates = await _getCoordinates(locationName);
      final latitude = coordinates['latitude'];
      final longitude = coordinates['longitude'];

      final formattedDate = '${date.year}-${_formatTwoDigits(date.month)}-${_formatTwoDigits(date.day)}';
      final url = '$_baseUrl/$latitude/$longitude/$formattedDate';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load past weather data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load past weather data: $e');
    }
  }


  Future<Map<String, dynamic>> _getCoordinates(String locationName) async {
    try {
      final openWeatherService = OpenWeatherService(_openWeatherApiKey);
      return await openWeatherService.searchLocation(locationName);
    } catch (e) {
      throw Exception('Failed to get coordinates: $e');
    }
  }

  String _formatTwoDigits(int number) {
    return number.toString().padLeft(2, '0');
  }
}

class OpenWeatherService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';
  String apiKey = 'c0d1009550c934bb96a545c2d2f38878';

  OpenWeatherService(this.apiKey);

  Future<Map<String, dynamic>> searchLocation(String locationName) async {
    final url = '$_baseUrl/weather?q=$locationName&appid=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      final coord = decodedData['coord'];
      final latitude = coord['lat'];
      final longitude = coord['lon'];
      return {'latitude': latitude, 'longitude': longitude};
    } else {
      throw Exception('Failed to search for location. Status Code: ${response.statusCode}');
    }
  }
}
