import 'package:flutter/material.dart';
import 'package:mine/models/weather.dart';

class DailyForecastWidget extends StatefulWidget {
  final List<Weather> dailyForecast;

  const DailyForecastWidget({
    Key? key,
    required this.dailyForecast,
  }) : super(key: key);

  @override
  _DailyForecastWidgetState createState() => _DailyForecastWidgetState();
}

class _DailyForecastWidgetState extends State<DailyForecastWidget> {
  bool _isCelsius = true;

  @override
  Widget build(BuildContext context) {
    final IconData defaultIcon = Icons.thermostat_rounded;
    final Color defaultBoxColor = Colors.lightBlue[100]!;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Forecast',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: Icon(Icons.swap_horiz),
                onPressed: () {
                  setState(() {
                    _isCelsius = !_isCelsius;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: widget.dailyForecast.map((weather) {
                final forecastDate = DateTime.now()
                    .add(Duration(days: widget.dailyForecast.indexOf(weather)));
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _buildForecastCard(
                      defaultIcon, defaultBoxColor, weather, forecastDate),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastCard(IconData defaultIcon, Color defaultBoxColor,
      Weather weather, DateTime forecastDate) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListTile(
            leading: Icon(
              defaultIcon,
              color: Colors.orange,
              size: 40,
            ),
            title: Text(
              '${_formatDate(forecastDate)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.blue,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isCelsius
                      ? '${weather.temperature.toStringAsFixed(1)}°C'
                      : '${_celsiusToFahrenheit(weather.temperature).toStringAsFixed(1)}°F',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Condition: ${weather.precipitationType} ',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  String _formatDate(DateTime date) {
    return '${_getWeekday(date.weekday)}, ${date.day}/${date.month}';
  }

  String _getWeekday(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }
}
