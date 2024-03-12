import 'package:flutter/material.dart';

class WeatherEventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Events'),
        // Display app logo as the leading widget in the app bar
        // leading: Image.asset('assets/logo.png'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            _buildNotifications(),
            SizedBox(height: 20),
            _buildInformationSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue, // Customize header color
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Display app name/logo
          Text(
            'Your App Name',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Navigation options can be added here
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Implement navigation logic here
            },
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildNotifications() {
    // Sample notifications for demonstration
    List<String> notifications = [
      'Severe thunderstorm warning: Take shelter immediately.',
      'Flash flood alert: Avoid driving through flooded areas.',
      'Tornado watch issued for your area: Stay tuned for updates.'
    ];

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notifications/Alerts',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          // Display notifications/alerts in a ListView
          ListView.builder(
            shrinkWrap: true,
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  notifications[index],
                  style: TextStyle(fontSize: 16),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInformationSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Information Section',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          // Add information about weather events and their impact
          Text(
            'Severe thunderstorm warning in effect until 7:00 PM. Potential for damaging winds and hail. Stay indoors and away from windows.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            'Flash flood alert for low-lying areas. Do not attempt to drive through flooded roads. Seek higher ground if in a flood-prone area.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            'Tornado watch issued. Monitor local news and weather updates. Have a plan in place for seeking shelter if necessary.',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
