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
                child: SizedBox(
                  width: 200,
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hour $index',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 12),
                          _buildWeatherInfo(
                            'Temperature',
                            '${weather.temperature}°C',
                          ),
                          _buildWeatherInfo(
                            'Feels Like',
                            '${weather.feelsLikeTemperature}°C',
                          ),
                          _buildWeatherInfo(
                            'Precipitation',
                            '${weather.precipitationAmount} mm ${weather.precipitationType ?? ''}',
                          ),
                          _buildWeatherInfo(
                            'Wind',
                            '${weather.windSpeed} km/h ${weather.windDirection ?? ''}',
                          ),
                          _buildWeatherInfo(
                            'Humidity',
                            '${weather.humidity ?? ''}%',
                          ),
                          _buildWeatherInfo(
                            'Chance of Rain',
                            '${weather.chanceOfRain ?? ''}%',
                          ),
                        ],
                      ),
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

  Widget _buildWeatherInfo(String label, String value) {
    return Column(
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
    );
  }
}
