import 'package:flutter/material.dart';
import 'package:mine/screens/past_weather_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mine/models/weather.dart';
import 'package:mine/screens/settings_screen.dart';
import 'package:mine/screens/weather_events_screen.dart';
import 'package:mine/services/location_service.dart';
import 'package:mine/services/weather_service.dart';
import 'package:mine/widgets/current_weather_widget.dart';
import 'package:mine/widgets/daily_forecast_widget.dart';
import 'package:mine/widgets/hourly_forecast_widget.dart';
import 'package:mine/widgets/recommendation_widget.dart';
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
  Weather currentWeather = Weather(temperature: 0);
  List<Weather> dailyForecast = [];
  List<Weather> hourlyForecast = [];
  String locationName = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    final PermissionStatus permissionStatus = await Permission.location.request();
    if (permissionStatus.isDenied) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Location Permission Required'),
          content: Text('To provide accurate weather forecast, please grant location permission.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => openAppSettings(),
              child: Text('Open Settings'),
            ),
          ],
        ),
      );
    } else if (permissionStatus.isGranted) {
      _fetchWeatherData();
    }
  }

  Future<void> _fetchWeatherData() async {
    setState(() {
      isLoading = true;
    });

    final locationService = LocationService();
    final weatherService = WeatherService(widget.apiKey);

    final permissionStatus = await Permission.location.request();
    if (permissionStatus.isGranted) {
      final position = await locationService.getCurrentLocation();
      final currentWeatherData = await weatherService.getCurrentWeather(position.latitude, position.longitude);
      final dailyForecastData = await weatherService.getDailyForecast(position.latitude, position.longitude);
      final hourlyForecastData = await weatherService.getHourlyForecast(position.latitude, position.longitude);

      setState(() {
        currentWeather = currentWeatherData;
        locationName = currentWeatherData.locationName!;
        dailyForecast = dailyForecastData;
        hourlyForecast = hourlyForecastData;
        isLoading = false;
      });
    }
  }

  Future<void> fetchWeatherDataForDate(DateTime selectedDate) async {
    try {
      final locationService = LocationService();
      final weatherService = WeatherService(widget.apiKey);

      final position = await locationService.getCurrentLocation();
      final lat = position.latitude;
      final lon = position.longitude;

      final weatherData = await weatherService.getWeatherForDate(lat, lon, selectedDate);

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

  Future<void> showSearchScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(
          apiKey: widget.apiKey,
          updateWeather: (Weather weather, List<Weather> dailyForecast, List<Weather> hourlyForecast, String locationName) {
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
      builder: (BuildContext context) => AlertDialog(
        title: Text('Recommendations'),
        content: RecommendationWidget(
          airQualityIndex: currentWeather.aqi?.toDouble() ?? 0,
          uvIndex: currentWeather.uvIndex?.toDouble() ?? 0,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weather Forecast',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () => showSearchScreen(context),
          ),
          IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.white),
            onPressed: _showDatePickerDialog,
          ),
          IconButton(
            icon: Icon(Icons.info, color: Colors.white),
            onPressed: () => _showRecommendation(context),
          ),
        ],
        backgroundColor: Colors.lightBlueAccent, // Change app bar color
        elevation: 0, // Remove app bar elevation
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Past Weather', style: TextStyle(fontSize: 16)),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PastWeatherScreen())),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings', style: TextStyle(fontSize: 16)),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen())),
            ),
            ListTile(
              leading: Icon(Icons.event),
              title: Text('Weather Events', style: TextStyle(fontSize: 16)),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WeatherEventsScreen())),
            ),

            ListTile(
              leading: Icon(Icons.feedback),
              title: Text('Feedback',style: TextStyle(fontSize: 16)),
              onTap: () {
                // Navigate to feedback screen or perform necessary actions
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLoading) // Show loading indicator if data is being fetched
              Center(child: CircularProgressIndicator()),
            if (!isLoading) // Show content only when not loading
              Column(
                children: [
                  CurrentWeatherWidget(currentWeather: currentWeather, locationName: locationName),
                  SizedBox(height: 20),
                  CropSuggestionWidget(
                    temperature: currentWeather.temperature,
                    humidity: double.tryParse(currentWeather.humidity.toString()) ?? 0,
                    precipitationType: currentWeather.precipitationType,
                    precipitationAmount: double.tryParse(currentWeather.precipitationAmount.toString()) ?? 0,
                  ),
                  SizedBox(height: 20),
                  HourlyForecastWidget(hourlyForecast: hourlyForecast),
                  SizedBox(height: 20),
                  DailyForecastWidget(dailyForecast: dailyForecast),
                  SizedBox(height: 20),
                ],
              ),
          ],
        ),
      ),
    );
  }

}
