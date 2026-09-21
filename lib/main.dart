import 'package:flutter/material.dart';
import 'screens/timer_screen.dart';
import 'theme/app_colors.dart';



void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodorino',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accent,
        ),
        fontFamily: 'Inter',
      ),
      home: const TimerScreen(),
    );
  }
}
