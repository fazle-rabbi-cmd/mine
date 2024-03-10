import 'package:flutter/material.dart';
import 'package:mine/models/weather.dart';

class CurrentWeatherWidget extends StatelessWidget {
  final Weather currentWeather;
  final String locationName; // Making locationName optional

  const CurrentWeatherWidget({
    Key? key,
    required this.currentWeather,
    required this.locationName, // Making locationName optional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locationName != null
              ? 'Current Weather in $locationName' // Display location name if available
              : 'Current Weather',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        _buildWeatherInfo(
            'Temperature', currentWeather.temperature.toString(), '°C'),
        _buildWeatherInfo('Feels Like',
            currentWeather.feelsLikeTemperature?.toString() ?? 'N/A', '°C'),
        _buildWeatherInfo('Precipitation', _getPrecipitation(), ''),
        _buildWeatherInfo('Wind Speed', _getWindSpeed(), ''),
        _buildWeatherInfo(
            'Humidity', currentWeather.humidity?.toString() ?? 'N/A', '%'),
        _buildWeatherInfo('Chance of Rain',
            currentWeather.chanceOfRain?.toString() ?? 'N/A', '%'),
        _buildWeatherInfo('AQI', currentWeather.aqi?.toString() ?? 'N/A', ''),
        _buildWeatherInfo(
            'UV Index', currentWeather.uvIndex?.toString() ?? 'N/A', ''),
        _buildWeatherInfo(
            'Pressure', currentWeather.pressure?.toString() ?? 'N/A', 'hPa'),
        _buildWeatherInfo(
            'Visibility', currentWeather.visibility?.toString() ?? 'N/A', 'km'),
        _buildWeatherInfo(
            'Sunrise Time', currentWeather.sunriseTime ?? 'N/A', ''),
        _buildWeatherInfo(
            'Sunset Time', currentWeather.sunsetTime ?? 'N/A', ''),
      ],
    );
  }

  Widget _buildWeatherInfo(String label, String value, String unit) {
    return Text('$label: $value$unit');
  }

  String _getPrecipitation() {
    if (currentWeather.precipitationType != null &&
        currentWeather.precipitationAmount != null) {
      return '${currentWeather.precipitationAmount} mm ${currentWeather.precipitationType}';
    } else if (currentWeather.precipitationType != null) {
      return currentWeather.precipitationType!;
    } else if (currentWeather.precipitationAmount != null) {
      return '${currentWeather.precipitationAmount} mm';
    } else {
      return 'N/A';
    }
  }

  String _getWindSpeed() {
    if (currentWeather.windSpeed != null &&
        currentWeather.windDirection != null) {
      return '${currentWeather.windSpeed} km/h ${currentWeather.windDirection}';
    } else if (currentWeather.windSpeed != null) {
      return '${currentWeather.windSpeed} ';
    } else if (currentWeather.windDirection != null) {
      return currentWeather.windDirection!;
    } else {
      return 'N/A';
    }
  }
}
