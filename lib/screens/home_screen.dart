import 'package:flutter/material.dart';
import 'package:mine/models/weather.dart';
import 'package:mine/services/location_service.dart';
import 'package:mine/services/weather_service.dart';
import 'package:mine/widgets/current_weather_widget.dart';
import 'package:mine/widgets/daily_forecast_widget.dart';
import 'package:mine/widgets/hourly_forecast_widget.dart';

import '../widgets/crop_suggestions_widget.dart';
import '../widgets/search_dialogue.dart'; // Import the search dialog
import '../widgets/date_picker_dialogue.dart'; // Import the date picker dialog

class HomeScreen extends StatefulWidget {
  final String apiKey;

  HomeScreen({required this.apiKey});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Weather currentWeather = Weather(
    temperature: 0,
    feelsLikeTemperature: 0,
    precipitationType: '',
    precipitationAmount: '',
    windSpeed: 0,
    windDirection: '',
    humidity: 0,
    chanceOfRain: 0,
    aqi: 0,
    uvIndex: 0,
    pressure: 0,
    visibility: 0,
    sunriseTime: '',
    sunsetTime: '',
    locationName: '',
    time: DateTime.now(),
  );

  List<Weather> dailyForecast = [];
  List<Weather> hourlyForecast = [];
  String locationName = ''; // Added locationName variable

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    try {
      final locationService = LocationService();
      final weatherService = WeatherService(widget.apiKey);

      final position = await locationService.getCurrentLocation();
      final lat = position.latitude;
      final lon = position.longitude;

      final currentWeatherData =
          await weatherService.getCurrentWeather(lat, lon);

      // Update locationName with current location's name
      setState(() {
        currentWeather = currentWeatherData;
        locationName = currentWeatherData.locationName!;
      });

      final dailyForecastData = await weatherService.getDailyForecast(lat, lon);
      final hourlyForecastData =
          await weatherService.getHourlyForecast(lat, lon);

      setState(() {
        dailyForecast = dailyForecastData;
        hourlyForecast = hourlyForecastData;
      });
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  // Method to fetch weather data for the selected date
  Future<void> fetchWeatherDataForDate(DateTime selectedDate) async {
    try {
      final locationService = LocationService();
      final weatherService = WeatherService(widget.apiKey);

      final position = await locationService.getCurrentLocation();
      final lat = position.latitude;
      final lon = position.longitude;

      // Fetch weather data for the selected date
      final weatherData =
          await weatherService.getWeatherForDate(lat, lon, selectedDate);
      // Update UI with weather data for the selected date
      setState(() {
        currentWeather = weatherData;
        locationName = weatherData.locationName!;
      });
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  // Method to show the date picker dialog
  Future<void> _showDatePickerDialog() async {
    showDatePickerDialog(context, (DateTime selectedDate) {
      // Handle selected date here
      fetchWeatherDataForDate(selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Forecast'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearchDialog(context, widget.apiKey, (Weather weather,
                  List<Weather> dailyForecast,
                  List<Weather> hourlyForecast,
                  String locationName) {
                setState(() {
                  currentWeather = weather;
                  this.dailyForecast = dailyForecast;
                  this.hourlyForecast = hourlyForecast;
                  this.locationName = locationName;
                });
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              _showDatePickerDialog();
            },
          ),
        ],
      ),
      // Add a drawer with options like settings and feedback
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Navigate to settings screen or perform necessary actions
              },
            ),
            ListTile(
              leading: Icon(Icons.feedback),
              title: Text('Feedback'),
              onTap: () {
                // Navigate to feedback screen or perform necessary actions
              },
            ),
            // Add more options as needed
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CurrentWeatherWidget(
                currentWeather: currentWeather,
                locationName: locationName, // Pass locationName
              ),
              SizedBox(height: 20),
              CropSuggestionWidget(
                temperature: currentWeather.temperature,
                humidity:
                    double.tryParse(currentWeather.humidity.toString()) ?? 0,
                precipitationType: currentWeather.precipitationType,
                precipitationAmount: double.tryParse(
                        currentWeather.precipitationAmount.toString()) ??
                    0,
              ),
              SizedBox(height: 20),
              HourlyForecastWidget(hourlyForecast: hourlyForecast),
              SizedBox(height: 20),
              DailyForecastWidget(dailyForecast: dailyForecast),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
