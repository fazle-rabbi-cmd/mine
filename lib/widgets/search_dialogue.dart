import 'package:flutter/material.dart';
import 'package:mine/models/weather.dart';
import 'package:mine/services/weather_service.dart';
import 'package:mine/services/location_service.dart';

Future<void> showSearchDialog(
    BuildContext context,
    String apiKey,
    Function(Weather, List<Weather>, List<Weather>, String)
        updateWeather) async {
  TextEditingController searchController = TextEditingController();
  String? tempLocationName;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Search Location'),
        content: TextField(
          controller: searchController,
          decoration: InputDecoration(hintText: 'Enter location name'),
          onChanged: (value) {
            tempLocationName = value;
          },
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Search'),
            onPressed: () async {
              if (tempLocationName != null && tempLocationName!.isNotEmpty) {
                final weatherService = WeatherService(apiKey);

                // Fetch data using the entered location name
                try {
                  final weatherData = await weatherService
                      .getWeatherByLocationName(tempLocationName!);
                  final dailyForecastData =
                      await weatherService.getDailyForecast(
                          weatherData.latitude ?? 0.0,
                          weatherData.longitude ?? 0.0);
                  final hourlyForecastData =
                      await weatherService.getHourlyForecast(
                          weatherData.latitude ?? 0.0,
                          weatherData.longitude ?? 0.0);

                  updateWeather(weatherData, dailyForecastData,
                      hourlyForecastData, tempLocationName!);
                } catch (e) {
                  print('Error fetching weather data: $e');
                }

                // Close the dialog
                Navigator.of(context).pop();
              }
            },
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Set Current Location'),
            onPressed: () async {
              final locationService = LocationService();
              final weatherService = WeatherService(apiKey);

              try {
                final position = await locationService.getCurrentLocation();
                final lat = position.latitude;
                final lon = position.longitude;

                // Fetch data using the current location
                final currentWeatherData =
                    await weatherService.getCurrentWeather(lat, lon);
                final dailyForecastData =
                    await weatherService.getDailyForecast(lat, lon);
                final hourlyForecastData =
                    await weatherService.getHourlyForecast(lat, lon);

                updateWeather(currentWeatherData, dailyForecastData,
                    hourlyForecastData, currentWeatherData.locationName!);
              } catch (e) {
                print('Error fetching weather data: $e');
              }

              // Close the dialog
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
