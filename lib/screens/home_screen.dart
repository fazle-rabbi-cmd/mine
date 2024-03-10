import 'package:flutter/material.dart';
import 'package:mine/models/weather.dart';
import 'package:mine/services/location_service.dart';
import 'package:mine/services/weather_service.dart';
import 'package:mine/widgets/current_weather_widget.dart';
import 'package:mine/widgets/daily_forecast_widget.dart';
import 'package:mine/widgets/hourly_forecast_widget.dart';

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

  // Method to show the search dialog
  Future<void> _showSearchDialog() async {
    TextEditingController searchController = TextEditingController();
    String? tempLocationName;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Search Location'),
          content: TextField(
            controller: searchController,
            decoration: InputDecoration(hintText: 'Enter location name'),
            onChanged: (value) {
              tempLocationName = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Search'),
              onPressed: () async {
                if (tempLocationName != null && tempLocationName!.isNotEmpty) {
                  final weatherService = WeatherService(widget.apiKey);

                  // Fetch data using the entered location name
                  try {
                    final weatherData = await weatherService
                        .getWeatherByLocationName(tempLocationName!);
                    final dailyForecastData =
                        await weatherService.getDailyForecast(
                            weatherData.latitude ?? 0.0,
                            weatherData.longitude ?? 0.0);
                    final hourlyForecastData =
                        await weatherService.getHourlyForecast(
                            weatherData.latitude ?? 0.0,
                            weatherData.longitude ?? 0.0);

                    setState(() {
                      currentWeather = weatherData;
                      dailyForecast = dailyForecastData;
                      hourlyForecast = hourlyForecastData;
                      locationName = tempLocationName!;
                    });
                  } catch (e) {
                    print('Error fetching weather data: $e');
                  }

                  // Close the dialog
                  Navigator.of(context).pop();
                }
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Set Current Location'),
              onPressed: () async {
                final locationService = LocationService();
                final weatherService = WeatherService(widget.apiKey);

                try {
                  final position = await locationService.getCurrentLocation();
                  final lat = position.latitude;
                  final lon = position.longitude;

                  // Fetch data using the current location
                  final currentWeatherData =
                      await weatherService.getCurrentWeather(lat, lon);
                  final dailyForecastData =
                      await weatherService.getDailyForecast(lat, lon);
                  final hourlyForecastData =
                      await weatherService.getHourlyForecast(lat, lon);

                  setState(() {
                    currentWeather = currentWeatherData;
                    dailyForecast = dailyForecastData;
                    hourlyForecast = hourlyForecastData;
                    locationName =
                        currentWeatherData.locationName!; // Update locationName
                  });
                } catch (e) {
                  print('Error fetching weather data: $e');
                }

                // Close the dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Method to show the date picker dialog
  Future<void> _showDatePickerDialog() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      // Handle selected date
    }
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
              _showSearchDialog();
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
