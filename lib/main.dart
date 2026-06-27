import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'home_screen.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adnan Mujahid | Software Engineer Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.surface,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          tertiary: AppColors.tertiary,
          surface: AppColors.surface,
        ),
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      home: const HomeScreen(),
    );
  }
}
