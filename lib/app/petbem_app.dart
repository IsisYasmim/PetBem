import 'package:flutter/material.dart';
import 'package:petbem/features/startup/presentation/splash_page.dart';

class PetBemApp extends StatelessWidget {
  const PetBemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetBem',
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
    );
  }
}
