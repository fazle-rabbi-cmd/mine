import 'package:flutter/material.dart';
import '../services/past_weather_service.dart';

class PastWeatherScreen extends StatefulWidget {
  @override
  _PastWeatherScreenState createState() => _PastWeatherScreenState();
}

class _PastWeatherScreenState extends State<PastWeatherScreen> {
  final WeatherService weatherService = WeatherService();
  Map<String, dynamic> weatherData = {};
  TextEditingController _dateController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchWeatherData(String location, String date) async {
    try {
      final data = await weatherService.getPastWeatherData(location, date);
      setState(() {
        weatherData = data;
      });
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Past Weather Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Enter Date (YYYY-MM-DD)',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Enter Location',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                fetchWeatherData(_locationController.text, _dateController.text);
              },
              child: Text('Search'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (weatherData.isNotEmpty)
                      ..._buildWeatherDataList(weatherData)
                    else
                      Text('No data available'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildWeatherDataList(Map<String, dynamic> data) {
    final List<dynamic> dataList = data['data'] ?? [];
    return dataList.map((item) => WeatherItemWidget(item: item)).toList();
  }
}

class WeatherItemWidget extends StatelessWidget {
  final Map<String, dynamic> item;

  const WeatherItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: item.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${entry.key}:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  entry.value.toString(),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
