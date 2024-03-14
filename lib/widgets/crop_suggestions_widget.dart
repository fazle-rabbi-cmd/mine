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

    return suggestedCrops.toSet().toList();
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
              color: Colors.green,
            ),
          ),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              for (String crop in crops)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Chip(
                    label: Text(
                      crop,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.green,
                    elevation: 3,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    labelPadding: EdgeInsets.symmetric(horizontal: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
