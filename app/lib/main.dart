import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/camera_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/recovery_timeline_screen.dart';
import 'screens/meet_remi_screen.dart';
import 'screens/conversational_signup_screen.dart';
import 'screens/welcome_back_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/healing_tracker_screen.dart';

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
      initialRoute: '/meet-remi',
      routes: {
        '/meet-remi': (context) => const MeetRemiScreen(),
        '/conversational-signup': (context) => const ConversationalSignupScreen(),
        '/welcome-back': (context) => const WelcomeBackScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/chat': (context) => const ChatScreen(),
        '/camera': (context) => const CameraScreen(),
        '/timeline': (context) => const RecoveryTimelineScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/healing-tracker': (context) => const HealingTrackerScreen(),
      },
    );
  }
}
