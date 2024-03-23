import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mine/models/weather.dart';

class CurrentWeatherWidget extends StatefulWidget {
  final Weather currentWeather;
  final String locationName;

  const CurrentWeatherWidget({Key? key, required this.currentWeather, required this.locationName}) : super(key: key);

  @override
  _CurrentWeatherWidgetState createState() => _CurrentWeatherWidgetState();
}

class _CurrentWeatherWidgetState extends State<CurrentWeatherWidget> {
  bool _isDetailedInfoVisible = false;

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
          Text(
            widget.locationName,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.currentWeather.temperature}°C',
                style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              if (_getPrecipitationIcon() != null) _buildWeatherIcon(_getPrecipitationIcon()!),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Feels Like ${_getValueOrNA(widget.currentWeather.feelsLikeTemperature)}°C',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          SizedBox(height: 10),
          Text(
            '${_getPrecipitation()}',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          SizedBox(height: 20),
          Divider(thickness: 1.5, color: Colors.grey[300]),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isDetailedInfoVisible = !_isDetailedInfoVisible;
              });
            },
            child: Text(
              _isDetailedInfoVisible ? 'Hide Details' : 'Show Details',
              style: TextStyle(color: Colors.black),
            ),
          ),
          if (_isDetailedInfoVisible) ...[


            _buildWeatherInfo('Wind Speed', _getWindSpeed(), '', Icons.air_outlined),
            _buildWeatherInfo('Humidity', _getValueOrNA(widget.currentWeather.humidity), '%', Icons.water_drop),
            _buildWeatherInfo('Chance of Rain', _getValueOrNA(widget.currentWeather.chanceOfRain), '%', Icons.beach_access),
            _buildWeatherInfo('AQI', _getValueOrNA(widget.currentWeather.aqi), '', Icons.air),
            _buildWeatherInfo('UV Index', _getValueOrNA(widget.currentWeather.uvIndex), '', Icons.wb_iridescent_rounded),
            _buildWeatherInfo('Pressure', _getValueOrNA(widget.currentWeather.pressure), 'hPa', Icons.compress),
            _buildWeatherInfo('Visibility', _getValueOrNA(widget.currentWeather.visibility), 'km', Icons.visibility_outlined),
            _buildWeatherInfo('Sunrise Time', widget.currentWeather.sunriseTime ?? 'N/A', '', Icons.wb_sunny_outlined),
            _buildWeatherInfo('Sunset Time', widget.currentWeather.sunsetTime ?? 'N/A', '', Icons.nightlight_round),
          ],
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
      width: 100,
      height: 100,
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
    return widget.currentWeather.precipitationType ?? 'N/A';
  }

  String _getWindSpeed() {
    if (widget.currentWeather.windSpeed != null && widget.currentWeather.windDirection != null) {
      return '${widget.currentWeather.windSpeed} km/h ${widget.currentWeather.windDirection}';
    } else if (widget.currentWeather.windSpeed != null) {
      return '${widget.currentWeather.windSpeed} ';
    } else if (widget.currentWeather.windDirection != null) {
      return widget.currentWeather.windDirection!;
    } else {
      return 'N/A';
    }
  }

  String _getValueOrNA(dynamic value) {
    return value?.toString() ?? 'N/A';
  }

  String? _getPrecipitationIcon() {
    if (widget.currentWeather.weatherIconCode != null) {
      String iconCode = widget.currentWeather.weatherIconCode!;
      return "https://www.weatherbit.io/static/img/icons/$iconCode.png";
    }
    return null;
  }
}
