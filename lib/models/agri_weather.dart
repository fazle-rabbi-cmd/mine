class AgriWeather {
  final double skinTemperature;
  final double averageTemperature;
  final double soilTemperature;
  final double shortwaveSolarRadiation;
  final double longwaveSolarRadiation;
  final double evapotranspiration;
  final double precipitation;
  final double specificHumidity;
  final double soilMoisture;
  final double windSpeed;
  final double pressure;
  final double bulkSoilDensity;
  final double volumetricSoilMoisture;

  AgriWeather({
    required this.skinTemperature,
    required this.averageTemperature,
    required this.soilTemperature,
    required this.shortwaveSolarRadiation,
    required this.longwaveSolarRadiation,
    required this.evapotranspiration,
    required this.precipitation,
    required this.specificHumidity,
    required this.soilMoisture,
    required this.windSpeed,
    required this.pressure,
    required this.bulkSoilDensity,
    required this.volumetricSoilMoisture,
  });

  factory AgriWeather.fromJson(Map<String, dynamic> json) {
    return AgriWeather(
      skinTemperature: json['skin_temp'] ?? 0.0,
      averageTemperature: json['temp'] ?? 0.0,
      soilTemperature: json['soil_temp'] ?? 0.0,
      shortwaveSolarRadiation: json['solar_rad'] ?? 0.0,
      longwaveSolarRadiation: json['solar_rad'] ?? 0.0,
      evapotranspiration: json['evapotranspiration'] ?? 0.0,
      precipitation: json['precip'] ?? 0.0,
      specificHumidity: json['specific_humidity'] ?? 0.0,
      soilMoisture: json['soil_moisture'] ?? 0.0,
      windSpeed: json['wind_spd'] ?? 0.0,
      pressure: json['pres'] ?? 0.0,
      bulkSoilDensity: json['bulk_density'] ?? 0.0,
      volumetricSoilMoisture: json['volumetric_moisture'] ?? 0.0,
    );
  }
}
