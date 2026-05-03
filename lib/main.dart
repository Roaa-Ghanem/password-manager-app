// lib/main.dart
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مدير كلمات المرور',
      theme: AppTheme.lightTheme, // استخدام الثيم المخصص
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}