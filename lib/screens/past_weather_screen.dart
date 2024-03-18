import 'package:flutter/material.dart';
import 'package:mine/services/past_weather_service.dart';
import 'package:mine/widgets/past_weather_display.dart'; // Import the widget

class PastWeatherScreen extends StatefulWidget {
  @override
  _PastWeatherScreenState createState() => _PastWeatherScreenState();
}

class _PastWeatherScreenState extends State<PastWeatherScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final PastWeatherService _openMeteoService = PastWeatherService('aa05b3052bf24c11b0a9cd580d0ca631');

  String _weatherData = '';

  @override
  void dispose() {
    _dateController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _searchWeatherData() async {
    final date = _dateController.text;
    final location = _locationController.text;

    try {
      final coordinates = await _openMeteoService.getCoordinates(location);
      final latitude = coordinates['latitude'];
      final longitude = coordinates['longitude'];
      final weatherData = await _openMeteoService.getPastWeather(latitude, longitude, date);
      setState(() {
        _weatherData = weatherData;
      });
    } catch (e) {
      print('Error fetching past weather data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Past Weather Data'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _searchWeatherData,
              child: Text('Search'),
            ),
            SizedBox(height: 16.0),
            PastWeatherDisplay(weatherData: _weatherData), // Use the widget here
          ],
        ),
      ),
    );
  }
}
