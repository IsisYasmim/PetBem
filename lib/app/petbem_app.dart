import 'package:flutter/material.dart';
import 'package:petbem/features/startup/presentation/splash_page.dart';

import 'theme/app_theme.dart';

class PetBemApp extends StatelessWidget {
  const PetBemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetBem',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SplashPage(),
    );
  }
}
