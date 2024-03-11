import 'package:flutter/material.dart';

class RecommendationWidget extends StatelessWidget {
  final double airQualityIndex; // Add air quality index
  final double uvIndex; // Add UV index

  RecommendationWidget({required this.airQualityIndex, required this.uvIndex});

  @override
  Widget build(BuildContext context) {
    String airQualityRecommendation =
        getAirQualityRecommendation(airQualityIndex);
    String uvRecommendation = getUVRecommendation(uvIndex);

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Recommendations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Air Quality Protection: \n$airQualityRecommendation',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8.0),
          Text(
            'Sun Protection: \n$uvRecommendation',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  String getAirQualityRecommendation(double airQualityIndex) {
    if (airQualityIndex >= 0 && airQualityIndex <= 50) {
      return 'Air quality is good. Enjoy outdoor activities.';
    } else if (airQualityIndex > 50 && airQualityIndex <= 100) {
      return 'Air quality is moderate. Sensitive individuals should consider reducing prolonged or heavy outdoor exertion.';
    } else if (airQualityIndex > 100 && airQualityIndex <= 150) {
      return 'Air quality is unhealthy for sensitive groups. People with respiratory or heart conditions, children, and older adults should reduce prolonged or heavy outdoor exertion.';
    } else if (airQualityIndex > 150 && airQualityIndex <= 200) {
      return 'Air quality is unhealthy. Everyone should reduce prolonged or heavy outdoor exertion.';
    } else if (airQualityIndex > 200 && airQualityIndex <= 300) {
      return 'Air quality is very unhealthy. Avoid outdoor activities and stay indoors as much as possible.';
    } else {
      return 'Air quality is hazardous. Avoid outdoor activities and stay indoors.';
    }
  }

  String getUVRecommendation(double uvIndex) {
    if (uvIndex >= 0 && uvIndex <= 2) {
      return 'UV index is low. Minimal protection required.';
    } else if (uvIndex > 2 && uvIndex <= 5) {
      return 'UV index is moderate. Wear sunglasses and use sunscreen.';
    } else if (uvIndex > 5 && uvIndex <= 7) {
      return 'UV index is high. Wear protective clothing, sunglasses, and apply sunscreen.';
    } else if (uvIndex > 7 && uvIndex <= 10) {
      return 'UV index is very high. Take extra precautions - use sunscreen, wear protective clothing, and limit sun exposure between 10 AM and 4 PM.';
    } else {
      return 'UV index is extreme. Avoid being outside during midday hours, seek shade, and protect yourself with clothing, a wide-brimmed hat, and sunglasses.';
    }
  }
}
