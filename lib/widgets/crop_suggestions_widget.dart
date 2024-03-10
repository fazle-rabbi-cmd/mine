import 'package:flutter/material.dart';

class CropSuggestionWidget extends StatelessWidget {
  final double temperature;
  final double? humidity;
  final String? precipitationType;
  final double? precipitationAmount;

  CropSuggestionWidget({
    required this.temperature,
    this.humidity,
    this.precipitationType,
    this.precipitationAmount,
  });

  List<String> suggestCrops() {
    List<String> suggestedCrops = [];

    // Temperature-based suggestions
    if (temperature >= 25 && temperature <= 35) {
      suggestedCrops.addAll(['Tomatoes', 'Peppers', 'Cucumbers']);
      if (temperature >= 28 && temperature <= 32) {
        suggestedCrops.add('Bell Peppers');
      }
    } else if (temperature >= 20 && temperature < 25) {
      suggestedCrops.addAll(['Lettuce', 'Spinach', 'Carrots']);
    } else if (temperature > 35) {
      suggestedCrops.addAll(['Cactus', 'Succulents']);
    } else if (temperature < 10) {
      suggestedCrops.addAll(['Cabbage', 'Broccoli', 'Kale']);
    }

    // Humidity-based suggestions
    if (humidity != null) {
      if (humidity! > 80) {
        suggestedCrops.addAll(['Rice', 'Bananas', 'Papayas']);
      } else if (humidity! > 60) {
        suggestedCrops.addAll(['Oranges', 'Mangoes', 'Pineapples']);
      } else if (humidity! < 40) {
        suggestedCrops.addAll(['Apples', 'Grapes', 'Peaches']);
      }
    }

    // Precipitation-based suggestions
    if (precipitationType != null && precipitationAmount != null) {
      if (precipitationType == 'rain') {
        if (precipitationAmount! > 20) {
          suggestedCrops.addAll(['Rice', 'Wheat', 'Corn']);
        }
        if (temperature > 10 && temperature < 25) {
          suggestedCrops.addAll(['Apples', 'Grapes', 'Peaches']);
        }
      } else if (precipitationType == 'snow') {
        if (precipitationAmount! > 10) {
          suggestedCrops.addAll(['Potatoes', 'Turnips', 'Beets']);
        }
        if (temperature < 5) {
          suggestedCrops.add('Winter Wheat');
        }
      } else if (precipitationType == 'hail') {
        if (precipitationAmount! > 5) {
          suggestedCrops.add('Strawberries');
        }
      }
    }

    return suggestedCrops
        .toSet()
        .toList(); // Remove duplicates and convert back to list
  }

  @override
  Widget build(BuildContext context) {
    List<String> crops = suggestCrops();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Suggested Crops',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(width: 16), // Add some padding at the beginning
              for (String crop in crops)
                Container(
                  margin: EdgeInsets.only(right: 8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    crop,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
