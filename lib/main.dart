import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import the provider package
import 'screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      // Wrap your MaterialApp with ChangeNotifierProvider
      create: (context) =>
          ThemeNotifier(), // Create an instance of ThemeNotifier
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      // Use Consumer to listen to theme changes
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'Weather Forecast App',
          debugShowCheckedModeBanner: false,
          theme: themeNotifier
              .currentTheme, // Use the current theme from ThemeNotifier
          home: HomeScreen(
            apiKey: 'aa05b3052bf24c11b0a9cd580d0ca631',
          ),
        );
      },
    );
  }
}

// Define a ChangeNotifier for managing the theme
class ThemeNotifier with ChangeNotifier {
  ThemeData _currentTheme = ThemeData.light();

  ThemeData get currentTheme => _currentTheme;

  void setDarkTheme(bool isDark) {
    _currentTheme =
        isDark ? ThemeData.dark() : ThemeData.light(); // Set the theme
    notifyListeners(); // Notify listeners to update the UI
  }
}
