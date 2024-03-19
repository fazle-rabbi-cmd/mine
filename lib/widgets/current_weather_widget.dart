import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mine/models/weather.dart';

class CurrentWeatherWidget extends StatelessWidget {
  final Weather currentWeather;
  final String locationName;

  const CurrentWeatherWidget({Key? key, required this.currentWeather, required this.locationName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 5, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                locationName != null ? 'Current Weather in $locationName' : 'Current Weather',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.calendar_today, color: Colors.grey[600], size: 28),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date', style: TextStyle(color: Colors.grey[600], fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text('${_formatDate(DateTime.now())}', style: TextStyle(color: Colors.black, fontSize: 14)),
                    ],
                  ),
                  SizedBox(width: 20),
                  Icon(Icons.access_time, color: Colors.grey[600], size: 28),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Time', style: TextStyle(color: Colors.grey[600], fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text('${_formatTime(DateTime.now())}', style: TextStyle(color: Colors.black, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Temperature', style: TextStyle(color: Colors.grey[600], fontSize: 20)),
                  SizedBox(height: 5),
                  Text('${currentWeather.temperature}°C', style: TextStyle(color: Colors.red, fontSize: 36, fontWeight: FontWeight.bold)),
                ],
              ),
              if (_getPrecipitationIcon() != null) _buildWeatherIcon(_getPrecipitationIcon()!),
            ],
          ),
          SizedBox(height: 20),
          Divider(thickness: 1.5, color: Colors.grey[300]),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWeatherInfo('Feels Like', _getValueOrNA(currentWeather.feelsLikeTemperature), '°C', Icons.thermostat_rounded),
              _buildWeatherInfo('Precipitation', _getPrecipitation(), '', Icons.water_outlined),
              _buildWeatherInfo('Wind Speed', _getWindSpeed(), '', Icons.air_outlined),
              _buildWeatherInfo('Humidity', _getValueOrNA(currentWeather.humidity), '%', Icons.water_outlined),
              _buildWeatherInfo('Chance of Rain', _getValueOrNA(currentWeather.chanceOfRain), '%', Icons.water_outlined),
              _buildWeatherInfo('AQI', _getValueOrNA(currentWeather.aqi), '', Icons.air_rounded),
              _buildWeatherInfo('UV Index', _getValueOrNA(currentWeather.uvIndex), '', Icons.wb_iridescent_rounded),
              _buildWeatherInfo('Pressure', _getValueOrNA(currentWeather.pressure), 'hPa', Icons.speed_outlined),
              _buildWeatherInfo('Visibility', _getValueOrNA(currentWeather.visibility), 'km', Icons.visibility_outlined),
              _buildWeatherInfo('Sunrise Time', currentWeather.sunriseTime ?? 'N/A', '', Icons.wb_sunny_outlined),
              _buildWeatherInfo('Sunset Time', currentWeather.sunsetTime ?? 'N/A', '', Icons.nightlight_round),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherInfo(String label, String value, String unit, IconData iconData) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(iconData, color: Colors.blue[300], size: 24),
          SizedBox(width: 10),
          Text('$label: $value$unit', style: TextStyle(color: Colors.black, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildWeatherIcon(String url) {
    return Image(
      image: NetworkImage(url),
      width: 150,
      height: 150,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
          );
        }
      },
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        return Icon(Icons.error); // Placeholder icon for error
      },
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

  String _formatDate(DateTime date) {
    return DateFormat('EEE, MMM d, yyyy').format(date);
  }

  String _getValueOrNA(dynamic value) {
    return value?.toString() ?? 'N/A';
  }

  String? _getPrecipitationIcon() {
    if (currentWeather.weatherIconCode != null) {
      String iconCode = currentWeather.weatherIconCode!;
      return "https://www.weatherbit.io/static/img/icons/$iconCode.png";
    }
    return null;
  }
}
