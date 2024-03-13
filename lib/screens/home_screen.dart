import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mine/models/weather.dart';
import 'package:mine/screens/settings_screen.dart';

import 'package:mine/services/location_service.dart';
import 'package:mine/services/weather_service.dart';
import 'package:mine/widgets/current_weather_widget.dart';
import 'package:mine/widgets/daily_forecast_widget.dart';
import 'package:mine/widgets/hourly_forecast_widget.dart';
import 'package:mine/widgets/recommendation_widget.dart';
import 'package:mine/screens/weather_events_screen.dart';
import 'package:mine/widgets/crop_suggestions_widget.dart';
import 'package:mine/widgets/search_dialogue.dart';
import 'package:mine/widgets/date_picker_dialogue.dart';

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
  String locationName = '';

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    final PermissionStatus permissionStatus = await Permission.location.request();
    if (permissionStatus.isDenied) {
      // Show a dialog informing the user about the importance of granting location permission
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Location Permission Required'),
            content: Text('To provide accurate weather forecast, please grant location permission.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Open app settings to allow the user to grant permission manually
                  openAppSettings();
                },
                child: Text('Open Settings'),
              ),
            ],
          );
        },
      );
    } else if (permissionStatus.isGranted) {
      // Permission is granted, fetch weather data
      _fetchWeatherData();
    }
  }


  Future<void> _fetchWeatherData() async {
    try {
      final locationService = LocationService();
      final weatherService = WeatherService(widget.apiKey);

      final permissionStatus = await Permission.location.request();
      if (permissionStatus.isGranted) {
        final position = await locationService.getCurrentLocation();
        final lat = position.latitude;
        final lon = position.longitude;

        final currentWeatherData = await weatherService.getCurrentWeather(lat, lon);

        setState(() {
          currentWeather = currentWeatherData;
          locationName = currentWeatherData.locationName!;
        });

        final dailyForecastData = await weatherService.getDailyForecast(lat, lon);
        final hourlyForecastData = await weatherService.getHourlyForecast(lat, lon);

        setState(() {
          dailyForecast = dailyForecastData;
          hourlyForecast = hourlyForecastData;


        });
      } else if (permissionStatus.isDenied) {
        // Handle permission denied scenario
      }
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }


  Future<void> fetchWeatherDataForDate(DateTime selectedDate) async {
    try {
      final locationService = LocationService();
      final weatherService = WeatherService(widget.apiKey);

      final position = await locationService.getCurrentLocation();
      final lat = position.latitude;
      final lon = position.longitude;

      final weatherData =
      await weatherService.getWeatherForDate(lat, lon, selectedDate);

      setState(() {
        currentWeather = weatherData;
        locationName = weatherData.locationName!;
      });
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  Future<void> _showDatePickerDialog() async {
    showDatePickerDialog(context, (DateTime selectedDate) {
      fetchWeatherDataForDate(selectedDate);
    });
  }

  Future<void> showSearchScreen(
      BuildContext context,
      String apiKey,
      Null Function(Weather weather, List<Weather> dailyForecast,
          List<Weather> hourlyForecast, String locationName)
      param2) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(
          apiKey: widget.apiKey,
          updateWeather: (Weather weather, List<Weather> dailyForecast,
              List<Weather> hourlyForecast, String locationName) {
            setState(() {
              currentWeather = weather;
              this.dailyForecast = dailyForecast;
              this.hourlyForecast = hourlyForecast;
              this.locationName = locationName;
            });
          },
        ),
      ),
    );
  }

  void _showRecommendation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Recommendations'),
          content: RecommendationWidget(
            airQualityIndex: currentWeather.aqi?.toDouble() ?? 0,
            uvIndex: currentWeather.uvIndex?.toDouble() ?? 0,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
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
              showSearchScreen(context, widget.apiKey, (Weather weather,
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
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              _showRecommendation(
                  context); // Call the method to show recommendations
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.event),
              title: Text('Weather Events'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WeatherEventsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.feedback),
              title: Text('Feedback'),
              onTap: () {
                // Navigate to feedback screen or perform necessary actions
              },
            ),
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
                locationName: locationName,
              ),
              SizedBox(height: 20),
              CropSuggestionWidget(
                temperature: currentWeather.temperature,
                humidity: double.tryParse(currentWeather.humidity.toString()) ??
                    0,
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