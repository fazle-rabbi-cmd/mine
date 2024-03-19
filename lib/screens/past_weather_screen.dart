import 'package:flutter/material.dart';
import 'package:mine/services/past_weather_service.dart'; // Adjust the import path as needed

class PastWeatherScreen extends StatefulWidget {
  @override
  _PastWeatherScreenState createState() => _PastWeatherScreenState();
}

class _PastWeatherScreenState extends State<PastWeatherScreen> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final PastWeatherService _pastWeatherService = PastWeatherService('aa05b3052bf24c11b0a9cd580d0ca631');

  String _weatherData = '';

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _searchWeatherData() async {
    final startDate = _startDateController.text;
    final endDate = _endDateController.text;
    final location = _locationController.text;

    try {
      final coordinates = await _pastWeatherService.getCoordinates(location);
      final latitude = coordinates['latitude'];
      final longitude = coordinates['longitude'];

      final weatherData = await _pastWeatherService.getPastWeather(latitude!, longitude!, startDate, endDate);
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
              controller: _startDateController,
              decoration: InputDecoration(labelText: 'Start Date (YYYY-MM-DD)'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _endDateController,
              decoration: InputDecoration(labelText: 'End Date (YYYY-MM-DD)'),
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
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _weatherData,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
