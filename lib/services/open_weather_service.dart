// open_weather_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenWeatherService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';
  String _apiKey;

  OpenWeatherService(this._apiKey);

  Future<Map<String, dynamic>> searchLocation(String locationName) async {
    try {
      final url = '$_baseUrl/weather?q=$locationName&appid=$_apiKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        final coord = decodedData['coord'];
        final latitude = coord['lat'];
        final longitude = coord['lon'];
        return {'latitude': latitude, 'longitude': longitude};
      } else {
        throw Exception('Failed to search for location');
      }
    } catch (e) {
      throw Exception('Failed to search for location: $e');
    }
  }
}
