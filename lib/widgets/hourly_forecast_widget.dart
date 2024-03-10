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
        Text(
          'Hourly Forecast',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Enable horizontal scrolling
          child: Row(
            children: hourlyForecast.map((weather) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Time: ${weather.time}'),
                        Text('Temperature: ${weather.temperature}°C'),
                        Text('Feels Like: ${weather.feelsLikeTemperature}°C'),
                        Text(
                            'Precipitation: ${weather.precipitationAmount} mm ${weather.precipitationType ?? ''}'),
                        Text(
                            'Wind: ${weather.windSpeed} km/h ${weather.windDirection ?? ''}'),
                        Text('Humidity: ${weather.humidity ?? ''}%'),
                        Text('Chance of Rain: ${weather.chanceOfRain ?? ''}%'),
                        // Text('AQI: ${weather.aqi ?? ''}'),
                        // Text('UV Index: ${weather.uvIndex ?? ''}'),
                        Text('Pressure: ${weather.pressure ?? ''} hPa'),
                        Text('Visibility: ${weather.visibility ?? ''} km'),
                      ],
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
}
