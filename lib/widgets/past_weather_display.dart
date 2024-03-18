import 'package:flutter/material.dart';

class PastWeatherDisplay extends StatelessWidget {
  final String weatherData;

  PastWeatherDisplay({required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Past Weather Data:',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            weatherData,
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
