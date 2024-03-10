import 'package:flutter/material.dart';
import 'package:mine/models/weather.dart';
import 'package:mine/services/weather_service.dart';
import 'package:mine/services/location_service.dart';

class SearchScreen extends StatelessWidget {
  final String apiKey;
  final Function(Weather, List<Weather>, List<Weather>, String) updateWeather;

  SearchScreen({
    required this.apiKey,
    required this.updateWeather,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SearchDialog(apiKey: apiKey, updateWeather: updateWeather),
      ),
    );
  }
}

class SearchDialog extends StatefulWidget {
  final String apiKey;
  final Function(Weather, List<Weather>, List<Weather>, String) updateWeather;

  SearchDialog({
    required this.apiKey,
    required this.updateWeather,
  });

  @override
  _SearchDialogState createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  String? _tempLocationName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Enter location name',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(12.0),
          ),
          onChanged: (value) {
            setState(() {
              _tempLocationName = value;
            });
          },
          onSubmitted: _searchLocation,
        ),
        SizedBox(height: 12.0),
        ElevatedButton(
          onPressed: () {
            _searchLocation(_searchController.text);
          },
          child: Text('Search'),
        ),
        SizedBox(height: 8.0),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        SizedBox(height: 8.0),
        TextButton(
          onPressed: _setCurrentLocation,
          child: Text('Use Current Location'),
        ),
      ],
    );
  }

  Future<void> _searchLocation(String value) async {
    if (value.isNotEmpty) {
      final weatherService = WeatherService(widget.apiKey);

      try {
        final weatherData =
            await weatherService.getWeatherByLocationName(value);
        final dailyForecastData = await weatherService.getDailyForecast(
          weatherData.latitude ?? 0.0,
          weatherData.longitude ?? 0.0,
        );
        final hourlyForecastData = await weatherService.getHourlyForecast(
          weatherData.latitude ?? 0.0,
          weatherData.longitude ?? 0.0,
        );

        widget.updateWeather(
          weatherData,
          dailyForecastData,
          hourlyForecastData,
          value,
        );

        Navigator.of(context).pop();
      } catch (e) {
        print('Error fetching weather data: $e');
      }
    }
  }

  Future<void> _setCurrentLocation() async {
    final locationService = LocationService();
    final weatherService = WeatherService(widget.apiKey);

    try {
      final position = await locationService.getCurrentLocation();
      final lat = position.latitude;
      final lon = position.longitude;

      final currentWeatherData =
          await weatherService.getCurrentWeather(lat, lon);
      final dailyForecastData = await weatherService.getDailyForecast(lat, lon);
      final hourlyForecastData =
          await weatherService.getHourlyForecast(lat, lon);

      widget.updateWeather(
        currentWeatherData,
        dailyForecastData,
        hourlyForecastData,
        currentWeatherData.locationName!,
      );

      Navigator.of(context).pop();
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }
}
