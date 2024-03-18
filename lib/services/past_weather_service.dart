import 'dart:convert';
import 'package:http/http.dart' as http;

class PastWeatherService {
  static const String _baseUrl = 'https://api.weatherbit.io/v2.0/current';
  String _apiKey;

  PastWeatherService(this._apiKey);

  Future<Map<String, dynamic>> getCoordinates(String locationName) async {
    try {
      final url = '$_baseUrl?key=$_apiKey&city=$locationName';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        final data = decodedData['data'][0];
        final latitude = data['lat'];
        final longitude = data['lon'];
        return {'latitude': latitude, 'longitude': longitude};
      } else {
        throw Exception('Failed to get coordinates. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get coordinates: $e');
    }
  }

  Future<String> getPastWeather(double latitude, double longitude, String date) async {
    try {
      final url = '$_baseUrl?key=$_apiKey&lat=$latitude&lon=$longitude&start_date=$date&end_date=$date';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load past weather data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load past weather data: $e');
    }
  }
}
