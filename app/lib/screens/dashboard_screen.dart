import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remi - Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome back! How are you feeling today?',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/chat');
              },
              icon: const Icon(Icons.chat),
              label: const Text('Talk to Remi'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/camera');
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Scan Wound / Tracker'),
            )
          ],
        ),
      ),
    );
  }
}
