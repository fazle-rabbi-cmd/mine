import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mine/models/weather.dart';

class CurrentWeatherWidget extends StatelessWidget {
  final Weather currentWeather;
  final String locationName;

  static const Map<String, IconData> precipitationIcons = {
    'rain': Icons.beach_access,
    'snow': Icons.ac_unit,
    'sleet': Icons.grain,
    'hail': Icons.umbrella,
    'drizzle': Icons.grain_outlined,
    'thunderstorm': Icons.flash_on,
    'mist': Icons.cloud,
    'freezing rain': Icons.ac_unit,
    'hurricane': Icons.warning,
    'sunny intervals': Icons.wb_sunny,
    'showers': Icons.bathtub,
    'blizzard': Icons.ac_unit,
    'tornado': Icons.warning,
    'haze': Icons.cloud_circle,
    'smoke': Icons.smoke_free,
    'volcanic ash': Icons.volcano,
    'clear sky': Icons.wb_sunny,
    'broken clouds': Icons.cloud_circle_outlined,
    'few clouds': Icons.cloud_queue,
    'scattered clouds': Icons.cloud,
  };

  static const Map<String, Color> precipitationColors = {
    'rain': Colors.blue,
    'snow': Colors.white,
    'sleet': Colors.blueGrey,
    'hail': Colors.grey,
    'drizzle': Colors.grey,
    'thunderstorm': Colors.yellow,
    'mist': Colors.grey,
    'freezing rain': Colors.lightBlue,
    'hurricane': Colors.red,
    'sunny intervals': Colors.yellow,
    'showers': Colors.blueGrey,
    'blizzard': Colors.white,
    'tornado': Colors.red,
    'haze': Colors.grey,
    'smoke': Colors.grey,
    'volcanic ash': Colors.grey,
    'clear sky': Colors.yellow,
    'broken clouds': Colors.grey,
    'few clouds': Colors.grey,
    'scattered clouds': Colors.grey,
  };

  const CurrentWeatherWidget({
    Key? key,
    required this.currentWeather,
    required this.locationName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData? precipitationIcon;
    Color? precipitationColor;

    if (currentWeather.precipitationType != null) {
      String precipitationType =
          currentWeather.precipitationType!.toLowerCase();
      precipitationIcon = precipitationIcons[precipitationType];
      precipitationColor = precipitationColors[precipitationType];
    }

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            locationName != null
                ? 'Current Weather in $locationName'
                : 'Current Weather',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Temperature: ${currentWeather.temperature}°C',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              if (precipitationIcon != null)
                Icon(
                  precipitationIcon,
                  color: precipitationColor,
                ),
            ],
          ),
          SizedBox(height: 10),
          _buildWeatherInfo(
            'Feels Like',
            currentWeather.feelsLikeTemperature?.toString() ?? 'N/A',
            '°C',
            Icons.thermostat_rounded,
            Colors.orange,
          ),
          _buildWeatherInfo(
            'Precipitation',
            _getPrecipitation(),
            '',
            Icons.water_outlined,
            Colors.green,
          ),
          _buildWeatherInfo(
            'Wind Speed',
            _getWindSpeed(),
            '',
            Icons.air_outlined,
            Colors.purple,
          ),
          _buildWeatherInfo(
            'Humidity',
            currentWeather.humidity?.toString() ?? 'N/A',
            '%',
            Icons.water_outlined,
            Colors.blue,
          ),
          _buildWeatherInfo(
            'Chance of Rain',
            currentWeather.chanceOfRain?.toString() ?? 'N/A',
            '%',
            Icons.water_outlined,
            Colors.indigo,
          ),
          _buildWeatherInfo(
            'AQI',
            currentWeather.aqi?.toString() ?? 'N/A',
            '',
            Icons.air_outlined,
            Colors.red,
          ),
          _buildWeatherInfo(
            'UV Index',
            currentWeather.uvIndex?.toString() ?? 'N/A',
            '',
            Icons.wb_sunny_outlined,
            Colors.yellow,
          ),
          _buildWeatherInfo(
            'Pressure',
            currentWeather.pressure?.toString() ?? 'N/A',
            'hPa',
            Icons.speed_outlined,
            Colors.teal,
          ),
          _buildWeatherInfo(
            'Visibility',
            currentWeather.visibility?.toString() ?? 'N/A',
            'km',
            Icons.visibility_outlined,
            Colors.lightBlue,
          ),
          _buildWeatherInfo(
            'Sunrise Time',
            currentWeather.sunriseTime ?? 'N/A',
            '',
            Icons.wb_sunny_outlined,
            Colors.yellow,
          ),
          _buildWeatherInfo(
            'Sunset Time',
            currentWeather.sunsetTime ?? 'N/A',
            '',
            Icons.nightlight_round,
            Colors.orange,
          ),
          _buildWeatherInfo(
            'Time',
            _formatTime(currentWeather.time),
            '',
            Icons.access_time,
            Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherInfo(
      String label, String value, String unit, IconData iconData, Color color) {
    return Row(
      children: [
        Icon(
          iconData,
          color: color,
        ),
        SizedBox(width: 5),
        Text(
          '$label: $value$unit',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
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

  String _formatTime(DateTime? time) {
    if (time != null) {
      return DateFormat.Hm().format(time);
    } else {
      return 'N/A';
    }
  }
}
