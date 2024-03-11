import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Variables to store user preferences
  bool _isCelsiusSelected = true;
  String _selectedLanguage = 'English';
  bool _isNotificationEnabled = true;
  bool _isDarkThemeEnabled = false;
  String _selectedRefreshInterval = 'Every 30 minutes';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        // Add your app logo as the leading widget
        // leading: Image.asset('assets/logo.png'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Units'),
          _buildUnitSelection(),
          _buildSectionHeader('Language'),
          _buildLanguageSelection(),
          _buildSectionHeader('Notification Preferences'),
          _buildNotificationPreferences(),
          _buildSectionHeader('Data Refresh Intervals'),
          _buildRefreshIntervalSelection(),
          _buildSectionHeader('Theme Change'),
          _buildThemeSwitch(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildUnitSelection() {
    return ListTile(
      title: Text('Temperature Units'),
      trailing: DropdownButton<String>(
        value: _isCelsiusSelected ? 'Celsius' : 'Fahrenheit',
        onChanged: (newValue) {
          setState(() {
            _isCelsiusSelected = newValue == 'Celsius';
          });
        },
        items: <String>['Celsius', 'Fahrenheit']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLanguageSelection() {
    return ListTile(
      title: Text('Preferred Language'),
      trailing: DropdownButton<String>(
        value: _selectedLanguage,
        onChanged: (newValue) {
          setState(() {
            _selectedLanguage = newValue!;
          });
        },
        items: <String>['English', 'Spanish', 'French']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotificationPreferences() {
    return SwitchListTile(
      title: Text('Enable Notifications'),
      value: _isNotificationEnabled,
      onChanged: (value) {
        setState(() {
          _isNotificationEnabled = value;
        });
      },
    );
  }

  Widget _buildRefreshIntervalSelection() {
    return ListTile(
      title: Text('Data Refresh Interval'),
      trailing: DropdownButton<String>(
        value: _selectedRefreshInterval,
        onChanged: (newValue) {
          setState(() {
            _selectedRefreshInterval = newValue!;
          });
        },
        items: <String>['Every 15 minutes', 'Every 30 minutes', 'Every hour']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildThemeSwitch() {
    return SwitchListTile(
      title: Text('Dark Theme'),
      value: _isDarkThemeEnabled,
      onChanged: (value) {
        setState(() {
          _isDarkThemeEnabled = value;
          // Apply theme change logic here
          if (_isDarkThemeEnabled) {
            Provider.of<ThemeNotifier>(context, listen: false)
                .setDarkTheme(true);
          } else {
            // Set the light theme
            Provider.of<ThemeNotifier>(context, listen: false)
                .setDarkTheme(false);
          }
        });
      },
    );
  }
}
