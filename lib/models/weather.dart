class Weather {
  final double temperature;
  final double? feelsLikeTemperature;
  final String? precipitationType;
  final String? precipitationAmount;
  final double? windSpeed;
  final String? windDirection;
  final int? humidity;
  final int? chanceOfRain;
  final int? aqi;
  final int? uvIndex;
  final int? pressure;
  final double? visibility;
  final String? sunriseTime;
  final String? sunsetTime;
  final DateTime? time;
  final String? locationName;
  final String? zone;
  final double? latitude; // Latitude property
  final double? longitude; // Longitude property

  Weather({
    required this.temperature,
    this.feelsLikeTemperature,
    this.precipitationType,
    this.precipitationAmount,
    this.windSpeed,
    this.windDirection,
    this.humidity,
    this.chanceOfRain,
    this.aqi,
    this.uvIndex,
    this.pressure,
    this.visibility,
    this.sunriseTime,
    this.sunsetTime,
    this.time,
    this.locationName,
    this.zone,
    this.latitude, // Include latitude in the constructor
    this.longitude, // Include longitude in the constructor
  });

  static Weather fromJson(Map<String, dynamic> data) {
    return Weather(
      temperature: data['temp'] ?? 0.0,
      feelsLikeTemperature: data['app_temp'] ?? 0.0,
      precipitationType: data['weather']['description'] ?? '',
      precipitationAmount: data['precip']?.toString() ?? '',
      windSpeed: data['wind_spd'] ?? 0.0,
      windDirection: data['wind_cdir_full'] ?? '',
      humidity: data['rh'] ?? 0,
      chanceOfRain: data['pop'] ?? 0,
      aqi: data['aqi'] ?? 0,
      uvIndex: data['uv']?.round() ?? 0,
      pressure: data['pres']?.round() ?? 0,
      visibility: data['vis'] ?? 0.0,
      sunriseTime: data['sunrise'] ?? '',
      sunsetTime: data['sunset'] ?? '',
      locationName: data['city_name'] ?? '',
      zone: data['timezone'] ?? '',
      latitude: data['lat'] ?? 0.0, // Assign latitude value
      longitude: data['lon'] ?? 0.0, // Assign longitude value
    );
  }
}
