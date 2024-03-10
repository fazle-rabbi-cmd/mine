// import 'package:flutter/material.dart';
//
// class CropSuggestionsWidget extends StatelessWidget {
//   List<String> getCropSuggestions() {
//     // Define your logic to determine crop suggestions without weather conditions
//     // You can base this on factors like seasonality, location, or general preferences
//     // For demonstration purposes, we'll provide some generic suggestions
//     return ['Tomatoes', 'Lettuce', 'Carrots', 'Bell Peppers'];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List<String> cropSuggestions = getCropSuggestions();
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Crop Suggestions:',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: 10),
//         if (cropSuggestions.isNotEmpty)
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: cropSuggestions
//                 .map((crop) => Text(
//                       '- $crop',
//                       style: TextStyle(fontSize: 16),
//                     ))
//                 .toList(),
//           )
//         else
//           Text(
//             'No crop suggestions available.',
//             style: TextStyle(fontSize: 16),
//           ),
//         SizedBox(height: 20),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';

import '../models/agri_weather.dart'; // Import your AgriWeather model

class CropSuggestionsWidget extends StatelessWidget {
  final AgriWeather agriWeather;

  CropSuggestionsWidget({required this.agriWeather});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Agricultural Weather Data:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Skin Temperature: ${agriWeather.skinTemperature}',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          'Average Temperature: ${agriWeather.averageTemperature}',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          'Soil Temperature: ${agriWeather.soilTemperature}',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          'Shortwave Solar Radiation: ${agriWeather.shortwaveSolarRadiation}',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          'Longwave Solar Radiation: ${agriWeather.longwaveSolarRadiation}',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          'Evapotranspiration: ${agriWeather.evapotranspiration}',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          'Precipitation: ${agriWeather.precipitation}',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          'Specific Humidity: ${agriWeather.specificHumidity}',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          'Soil Moisture: ${agriWeather.soilMoisture}',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          'Wind Speed: ${agriWeather.windSpeed}',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          'Pressure: ${agriWeather.pressure}',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          'Bulk Soil Density: ${agriWeather.bulkSoilDensity}',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          'Volumetric Soil Moisture: ${agriWeather.volumetricSoilMoisture}',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
