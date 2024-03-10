import 'package:flutter/material.dart';

class CropSuggestionsWidget extends StatelessWidget {
  List<String> getCropSuggestions() {
    // Define your logic to determine crop suggestions without weather conditions
    // You can base this on factors like seasonality, location, or general preferences
    // For demonstration purposes, we'll provide some generic suggestions
    return ['Tomatoes', 'Lettuce', 'Carrots', 'Bell Peppers'];
  }

  @override
  Widget build(BuildContext context) {
    List<String> cropSuggestions = getCropSuggestions();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Crop Suggestions:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        if (cropSuggestions.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: cropSuggestions
                .map((crop) => Text(
                      '- $crop',
                      style: TextStyle(fontSize: 16),
                    ))
                .toList(),
          )
        else
          Text(
            'No crop suggestions available.',
            style: TextStyle(fontSize: 16),
          ),
        SizedBox(height: 20),
      ],
    );
  }
}
