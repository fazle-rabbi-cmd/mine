import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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
        Container(
          height: 200,
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: LineChart(
            LineChartData(
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: _generateSpots(hourlyForecast),
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 4,
                  dotData: FlDotData(show: false),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Colors.blue.withOpacity(0.8),
                  getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                    return touchedBarSpots.map((barSpot) {
                      final index = barSpot.x.toInt();
                      final weather = hourlyForecast[index];
                      return LineTooltipItem(
                        '${_formatTemperature(weather.temperature)} °C\n'
                            '${weather.precipitationType ?? 'No Precipitation'}, '
                            '${weather.chanceOfRain ?? '0'}% Chance of Rain\n'
                            'Humidity: ${weather.humidity ?? 'N/A'}%\n'
                            'Pressure: ${weather.pressure ?? 'N/A'} hPa',
                        TextStyle(color: Colors.white),
                      );
                    }).toList();
                  },
                ),
              ),
              minY: 0,
              gridData: FlGridData(show: false),
            ),
          ),
        ),
      ],
    );
  }

  String _formatTemperature(double temperature) {
    return temperature.toStringAsFixed(1);
  }

  List<FlSpot> _generateSpots(List<Weather> hourlyForecast) {
    return hourlyForecast.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final weather = entry.value;
      return FlSpot(index, weather.temperature);
    }).toList();
  }
}
