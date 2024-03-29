import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/weather_events_screen.dart';
import 'services/notification_service.dart'; // Import the NotificationService

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeNotifier()),
        Provider<NotificationService>(create: (_) => NotificationService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final notificationService = Provider.of<NotificationService>(context, listen: false);

    // Initialize notification service
    notificationService.initialize();

    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Weather Forecast App',
          debugShowCheckedModeBanner: false,
          theme: themeNotifier.currentTheme,
          // Define the initial route or home screen
          initialRoute: '/home',
          routes: {
            '/home': (context) => HomeScreen(apiKey: 'aa05b3052bf24c11b0a9cd580d0ca631'),
            '/settings': (context) => SettingsScreen(),
            '/weatherEventsScreen': (context) => WeatherEventsScreen(),
          },
        );
      },
    );
  }
}

class ThemeNotifier with ChangeNotifier {
  ThemeData _currentTheme = ThemeData.light();

  ThemeData get currentTheme => _currentTheme;

  void setDarkTheme(bool isDark) {
    _currentTheme = isDark ? ThemeData.dark() : ThemeData.light();
    notifyListeners();
  }
}
