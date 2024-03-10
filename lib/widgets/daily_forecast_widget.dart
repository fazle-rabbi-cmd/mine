import 'package:flutter/material.dart';
import 'package:mine/models/weather.dart';

class DailyForecastWidget extends StatelessWidget {
  final List<Weather> dailyForecast;

  const DailyForecastWidget({
    Key? key,
    required this.dailyForecast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Forecast',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          itemCount: dailyForecast.length,
          itemBuilder: (context, index) {
            final weather = dailyForecast[index];
            return ListTile(
              title: Text('Day ${index + 1}'),
              subtitle: Text(
                'Temperature: ${weather.temperature}°C, Precipitation: ${weather.precipitationAmount} mm ${weather.precipitationType}',
              ),
            );
          },
        ),
      ],
    );
  }
}
