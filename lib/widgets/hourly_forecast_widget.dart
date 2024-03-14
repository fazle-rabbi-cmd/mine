import 'package:flutter/material.dart';
import 'package:mine/models/weather.dart';

class HourlyForecastWidget extends StatelessWidget {
  final List<Weather> hourlyForecast;

  const HourlyForecastWidget({
    Key? key,
    required this.hourlyForecast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 4.0),
          child: Text(
            'Hourly Forecast',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: hourlyForecast.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final weather = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () => _showHourlyDetailsDialog(context, index, weather),
                  child: FadeIn(
                    duration: Duration(milliseconds: 500),
                    child: SizedBox(
                      width: 200,
                      child: _buildHourlyCard(index, weather),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildHourlyCard(int index, Weather weather) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hour $index',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.blue,
                  ),
                ),
                Icon(
                  Icons.cloud,
                  color: Colors.blue,
                ),
              ],
            ),
            SizedBox(height: 12),
            _buildWeatherInfo(Icons.thermostat, 'Temperature', '${weather.temperature}°C'),
            _buildWeatherInfo(Icons.thermostat_outlined, 'Feels Like', '${weather.feelsLikeTemperature}°C'),
            _buildWeatherInfo(Icons.waves, 'Precipitation', '${weather.precipitationAmount} mm ${weather.precipitationType ?? ''}'),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherInfo(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  void _showHourlyDetailsDialog(BuildContext context, int index, Weather weather) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hour $index Forecast Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(Icons.thermostat, 'Temperature', '${weather.temperature}°C'),
                _buildDetailRow(Icons.thermostat_outlined, 'Feels Like', '${weather.feelsLikeTemperature}°C'),
                _buildDetailRow(Icons.waves, 'Precipitation', '${weather.precipitationAmount} mm ${weather.precipitationType ?? ''}'),
                _buildDetailRow(Icons.air, 'Wind', '${weather.windSpeed} km/h ${weather.windDirection ?? ''}'),
                _buildDetailRow(Icons.water_damage, 'Humidity', '${weather.humidity ?? ''}%'),
                _buildDetailRow(Icons.wb_sunny, 'Chance of Rain', '${weather.chanceOfRain ?? ''}%'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.white,
          elevation: 8.0,
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
}

class FadeIn extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const FadeIn({Key? key, required this.child, this.duration = const Duration(milliseconds: 300)}) : super(key: key);

  @override
  _FadeInState createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}
