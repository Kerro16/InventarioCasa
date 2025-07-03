import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      body: Center(
        child: Image.asset(
          'assets/fridge.png',
          width: 160,
          height: 160,
        ),
      ),
    );
  }
}