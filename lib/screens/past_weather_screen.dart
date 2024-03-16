import 'package:flutter/material.dart';
import 'package:mine/services/open_meteo_service.dart';

class PastWeatherScreen extends StatefulWidget {
  @override
  _PastWeatherScreenState createState() => _PastWeatherScreenState();
}

class _PastWeatherScreenState extends State<PastWeatherScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final OpenMeteoService _openMeteoService = OpenMeteoService('c0d1009550c934bb96a545c2d2f38878');

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
      final weatherData = await _openMeteoService.getPastWeather(location, DateTime.parse(date));
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
