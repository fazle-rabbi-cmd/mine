import 'package:flutter/material.dart';
import 'package:mine/models/weather.dart';

class CurrentWeatherWidget extends StatelessWidget {
  final Weather currentWeather;
  final String locationName; // Making locationName optional

  // Map to store precipitation types and their corresponding icons
  static const Map<String, IconData> precipitationIcons = {
    'rain': Icons.beach_access,
    'snow': Icons.ac_unit,
    'sleet': Icons.grain,
    'hail': Icons.filter_drama,
    'drizzle': Icons.grain, // Can be replaced with a specific drizzle icon
    'thunderstorm': Icons.flash_on,
    'fog': Icons.filter_drama,
    'mist': Icons.filter_drama,
    'freezing rain': Icons.ac_unit, // You can replace this with a suitable icon
    'hurricane': Icons.warning, // Example icon, can be changed
    'sunny intervals': Icons.wb_sunny,
    'showers': Icons.beach_access, // Example icon, can be changed
    'blizzard': Icons.ac_unit, // Example icon, can be changed
    'sandstorm': Icons.grain, // Example icon, can be changed
    'tornado': Icons.warning, // Example icon, can be changed
    'haze': Icons.filter_drama, // Example icon, can be changed
    'smoke': Icons.whatshot, // Example icon, can be changed
    'volcanic ash': Icons.volcano_outlined, // Example icon, can be changed
    'clear sky': Icons.wb_sunny, // Example icon, can be changed
    'broken clouds': Icons.cloud_outlined, // Example icon, can be changed
    'few clouds': Icons.cloud_outlined, // Example icon, can be changed
    'scattered clouds': Icons.cloud_outlined, // Example icon, can be changed
    // Add more precipitation types and their icons as needed
  };

  const CurrentWeatherWidget({
    Key? key,
    required this.currentWeather,
    required this.locationName, // Making locationName optional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData? precipitationIcon;
    String? precipitationType;

    if (currentWeather.precipitationType != null) {
      precipitationType = currentWeather.precipitationType!.toLowerCase();
      // Get the corresponding icon for the precipitation type from the map
      precipitationIcon = precipitationIcons[precipitationType];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
            if (precipitationIcon != null)
              Icon(
                precipitationIcon,
                color: Colors.blue, // Change the color here
              ), // Display precipitation icon if available
          ],
        ),
        SizedBox(height: 10),
        _buildWeatherInfo(
          'Temperature',
          currentWeather.temperature.toString(),
          '°C',
          Icons.thermostat_outlined, // Icon for temperature
        ),
        _buildWeatherInfo(
          'Feels Like',
          currentWeather.feelsLikeTemperature?.toString() ?? 'N/A',
          '°C',
          Icons.thermostat_outlined, // Icon for feels like temperature
        ),
        _buildWeatherInfo(
          'Precipitation',
          _getPrecipitation(),
          '',
          Icons.water_outlined, // Icon for precipitation
        ),
        _buildWeatherInfo(
          'Wind Speed',
          _getWindSpeed(),
          '',
          Icons.air_outlined, // Icon for wind speed
        ),
        _buildWeatherInfo(
          'Humidity',
          currentWeather.humidity?.toString() ?? 'N/A',
          '%',
          Icons.water_outlined, // Icon for humidity
        ),
        _buildWeatherInfo(
          'Chance of Rain',
          currentWeather.chanceOfRain?.toString() ?? 'N/A',
          '%',
          Icons.water_outlined, // Icon for chance of rain
        ),
        _buildWeatherInfo(
          'AQI',
          currentWeather.aqi?.toString() ?? 'N/A',
          '',
          Icons.air_outlined, // Icon for AQI
        ),
        _buildWeatherInfo(
          'UV Index',
          currentWeather.uvIndex?.toString() ?? 'N/A',
          '',
          Icons.wb_sunny_outlined, // Icon for UV Index
        ),
        _buildWeatherInfo(
          'Pressure',
          currentWeather.pressure?.toString() ?? 'N/A',
          'hPa',
          Icons.speed_outlined, // Icon for pressure
        ),
        _buildWeatherInfo(
          'Visibility',
          currentWeather.visibility?.toString() ?? 'N/A',
          'km',
          Icons.visibility_outlined, // Icon for visibility
        ),
        _buildWeatherInfo(
          'Sunrise Time',
          currentWeather.sunriseTime ?? 'N/A',
          '',
          Icons.wb_sunny_outlined, // Icon for sunrise time
        ),
        _buildWeatherInfo(
          'Sunset Time',
          currentWeather.sunsetTime ?? 'N/A',
          '',
          Icons.nightlight_round, // Icon for sunset time
        ),
      ],
    );
  }

  Widget _buildWeatherInfo(
      String label, String value, String unit, IconData iconData) {
    return Row(
      children: [
        Icon(iconData, color: Colors.blue), // Change the color here
        SizedBox(width: 5),
        Text('$label: $value$unit'),
      ],
    );
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
