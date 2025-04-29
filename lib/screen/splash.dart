import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: CircularProgressIndicator(
         color: Color.fromARGB(255, 231, 93, 255),
         strokeWidth: 3,
        )
      )
    );
  }
}