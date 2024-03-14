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
    'fog': Icons.foggy,
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

  const CurrentWeatherWidget({
    Key? key,
    required this.currentWeather,
    required this.locationName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData? precipitationIcon = _getPrecipitationIcon();

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
          _buildTitle(),
          SizedBox(height: 20),
          _buildTemperatureRow(),
          SizedBox(height: 20),
          Divider(
            thickness: 1.5,
            color: Colors.grey[300],
          ),
          SizedBox(height: 20),
          _buildWeatherDetails(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      locationName != null
          ? 'Current Weather in $locationName'
          : 'Current Weather',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildTemperatureRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Temperature',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 20,
              ),
            ),
            SizedBox(height: 5),
            Text(
              '${currentWeather.temperature}°C',
              style: TextStyle(
                color: Colors.black,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (_getPrecipitationIcon() != null)
          Icon(
            _getPrecipitationIcon(),
            size: 80,
            color: Colors.blue[300],
          ),
      ],
    );
  }

  Widget _buildWeatherDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWeatherInfo(
            'Feels Like',
            currentWeather.feelsLikeTemperature?.toString() ?? 'N/A',
            '°C',
            Icons.thermostat_rounded),
        _buildWeatherInfo(
            'Precipitation', _getPrecipitation(), '', Icons.water_outlined),
        _buildWeatherInfo(
            'Wind Speed', _getWindSpeed(), '', Icons.air_outlined),
        _buildWeatherInfo(
            'Humidity',
            currentWeather.humidity?.toString() ?? 'N/A',
            '%',
            Icons.water_outlined),
        _buildWeatherInfo(
            'Chance of Rain',
            currentWeather.chanceOfRain?.toString() ?? 'N/A',
            '%',
            Icons.water_outlined),
        _buildWeatherInfo('AQI', currentWeather.aqi?.toString() ?? 'N/A', '',
            Icons.air_outlined),
        _buildWeatherInfo(
            'UV Index',
            currentWeather.uvIndex?.toString() ?? 'N/A',
            '',
            Icons.wb_sunny_outlined),
        _buildWeatherInfo(
            'Pressure',
            currentWeather.pressure?.toString() ?? 'N/A',
            'hPa',
            Icons.speed_outlined),
        _buildWeatherInfo(
            'Visibility',
            currentWeather.visibility?.toString() ?? 'N/A',
            'km',
            Icons.visibility_outlined),
        _buildWeatherInfo('Sunrise Time', currentWeather.sunriseTime ?? 'N/A',
            '', Icons.wb_sunny_outlined),
        _buildWeatherInfo('Sunset Time', currentWeather.sunsetTime ?? 'N/A', '',
            Icons.nightlight_round),
        _buildWeatherInfo(
            'Time', _formatTime(currentWeather.time), '', Icons.access_time),
      ],
    );
  }

  Widget _buildWeatherInfo(
      String label, String value, String unit, IconData iconData) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            iconData,
            color: Colors.blue[300],
            size: 24,
          ),
          SizedBox(width: 10),
          Text(
            '$label: $value$unit',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  IconData? _getPrecipitationIcon() {
    if (currentWeather.precipitationType != null) {
      String precipitationType =
      currentWeather.precipitationType!.toLowerCase();
      return precipitationIcons[precipitationType];
    }
    return null;
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
    return time != null ? DateFormat.Hm().format(time) : 'N/A';
  }
}
