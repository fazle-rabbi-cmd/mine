import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mine/models/weather.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class CurrentWeatherWidget extends StatelessWidget {
  final Weather currentWeather;
  final String locationName;

  const CurrentWeatherWidget({
    Key? key,
    required this.currentWeather,
    required this.locationName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTemperature(),
          if (_getPrecipitationIcon() != null)
            _buildSvgPicture(_getPrecipitationIcon()!),
        ],
      ),
    );
  }


  Widget _buildTemperature() {
    return Column(
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
    );
  }

  Widget _buildWeatherDetails() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWeatherInfo(
              'Feels Like',
              currentWeather.feelsLikeTemperature?.toString() ?? 'N/A',
              '°C',
              Icons.thermostat_rounded),
          _buildWeatherInfo('Precipitation', _getPrecipitation(), '', Icons.water_outlined),
          _buildWeatherInfo('Wind Speed', _getWindSpeed(), '', Icons.air_outlined),
          _buildWeatherInfo('Humidity', currentWeather.humidity?.toString() ?? 'N/A', '%', Icons.water_outlined),
          _buildWeatherInfo('Chance of Rain', currentWeather.chanceOfRain?.toString() ?? 'N/A', '%', Icons.water_outlined),
          _buildWeatherInfo('AQI', currentWeather.aqi?.toString() ?? 'N/A', '', Icons.air_outlined),
          _buildWeatherInfo('UV Index', currentWeather.uvIndex?.toString() ?? 'N/A', '', Icons.wb_sunny_outlined),
          _buildWeatherInfo('Pressure', currentWeather.pressure?.toString() ?? 'N/A', 'hPa', Icons.speed_outlined),
          _buildWeatherInfo('Visibility', currentWeather.visibility?.toString() ?? 'N/A', 'km', Icons.visibility_outlined),
          _buildWeatherInfo('Sunrise Time', currentWeather.sunriseTime ?? 'N/A', '', Icons.wb_sunny_outlined),
          _buildWeatherInfo('Sunset Time', currentWeather.sunsetTime ?? 'N/A', '', Icons.nightlight_round),
          _buildWeatherInfo('Time', _formatTime(currentWeather.time), '', Icons.access_time),
        ],
      ),
    );
  }


  Widget _buildWeatherInfo(String label, String value, String unit, IconData iconData) {
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

  String _getPrecipitation() {
    return currentWeather.precipitationType ?? 'N/A';
  }

  String _getWindSpeed() {
    if (currentWeather.windSpeed != null && currentWeather.windDirection != null) {
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

  Widget _buildSvgPicture(String url) {
    return Image(
      image: NetworkImage(url),
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                : null,
          );
        }
      },
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        return Icon(Icons.error); // Placeholder icon for error
      },
    );
  }




  Future<Uint8List> _loadSvgImage(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Uint8List bytes = response.bodyBytes;
      return bytes;
    } else {
      throw Exception('Failed to load SVG');
    }
  }

  String? _getPrecipitationIcon() {
    if (currentWeather.weatherIconCode != null) {
      String iconCode = currentWeather.weatherIconCode!;
      return "https://www.weatherbit.io/static/img/icons/$iconCode.png";
    }
    return null;
  }

}
