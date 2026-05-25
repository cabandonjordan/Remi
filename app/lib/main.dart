import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/camera_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardScreen(),
        '/chat': (context) => const ChatScreen(),
        '/camera': (context) => const CameraScreen(),
      },
    );
  }
}
