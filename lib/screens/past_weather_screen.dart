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
      print('fetched weather data: $weatherData');
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
    final List<Widget> widgets = [];

    data.entries.forEach((entry) {
      final String label = _getLabel(entry.key);
      // Skip the 'data' field
      if (entry.key != 'data') {
        widgets.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            '$label: ${entry.value}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ));
      }
    });

    final List<dynamic> dataList = data['data'] ?? [];
    dataList.forEach((item) {
      widgets.add(_buildWeatherItemWidget(item));
    });

    return widgets;
  }


  Widget _buildWeatherItemWidget(Map<String, dynamic> item) {
    final List<Widget> widgets = [];
    item.entries.forEach((entry) {
      final String label = _getLabel(entry.key);
      final dynamic value = entry.value;
      if (value != null && value != '') { // Check if value is not empty or null
        widgets.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '$label:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  value.toString(),
                ),
              ),
            ],
          ),
        ));
      }
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }


  String _getLabel(String key) {
    // Mapping of keys to their corresponding labels
    final Map<String, String> labelMap = {
      'city_id': 'City ID',
      'city_name': 'City',
      'country_code': 'Country Code',
      'clouds': 'Clouds',
      'datetime': 'Date Time',
      'dewpt': 'Dew Point',
      'dhi': 'Diffuse Horizontal Irradiance',
      'dni': 'Direct Normal Irradiance',
      'ghi': 'Global Horizontal Irradiance',
      'max_dhi': 'Max Diffuse Horizontal Irradiance',
      'max_dni': 'Max Direct Normal Irradiance',
      'max_ghi': 'Max Global Horizontal Irradiance',
      'max_temp': 'Max Temperature',
      'max_temp_ts': 'Max Temperature Timestamp',
      'max_uv': 'Max UV',
      'max_wind_dir': 'Max Wind Direction',
      'max_wind_spd': 'Max Wind Speed',
      'max_wind_spd_ts': 'Max Wind Speed Timestamp',
      'min_temp': 'Min Temperature',
      'min_temp_ts': 'Min Temperature Timestamp',
      'precip': 'Precipitation',
      'precip_gpm': 'Precipitation GPM',
      'pres': 'Pressure',
      'revision_status': 'Revision Status',
      'rh': 'Relative Humidity',
      'slp': 'Sea Level Pressure',
      'snow': 'Snow',
      'snow_depth': 'Snow Depth',
      'solar_rad': 'Solar Radiation',
      't_dhi': 'Total Diffuse Horizontal Irradiance',
      't_dni': 'Total Direct Normal Irradiance',
      't_ghi': 'Total Global Horizontal Irradiance',
      't_solar_rad': 'Total Solar Radiation',
      'temp': 'Temperature',
      'ts': 'Timestamp',
      'wind_dir': 'Wind Direction',
      'wind_gust_spd': 'Wind Gust Speed',
      'wind_spd': 'Wind Speed',
      'lat': 'Latitude',
      'lon': 'Longitude',
      'sources': 'Sources',
      'state_code': 'State Code',
      'station_id': 'Station ID',
      'timezone': 'Timezone',
    };
    return labelMap[key] ?? key; // If key not found in map, use the original key
  }

}
