import 'package:flutter/material.dart';
import 'package:practica_006/core/theme/app_theme.dart';
import 'package:practica_006/features/timer/presentation/screens/timer_screen.dart';


/// The TimerApp class is a StatelessWidget that represents an app with a timer screen.
class TimerApp extends StatelessWidget {
  const TimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Timer',
      theme: AppTheme().getTheme(),
      home: const TimerScreen(),
    );
  }
}