import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:petbem/features/startup/presentation/splash_page.dart';

import '../features/profile/data/local_profile_repository.dart';
import '../features/profile/domain/repositories/profile_repository.dart';
import '../features/profile/presentation/profile_controller.dart';
import '../features/profile/presentation/profile_scope.dart';
import 'theme/app_theme.dart';

class PetBemApp extends StatefulWidget {
  const PetBemApp({super.key, this.profileRepository});

  final ProfileRepository? profileRepository;

  @override
  State<PetBemApp> createState() => _PetBemAppState();
}

class _PetBemAppState extends State<PetBemApp> {
  late final ProfileController _profileController;

  @override
  void initState() {
    super.initState();
    _profileController = ProfileController(
      widget.profileRepository ?? LocalProfileRepository(),
    );
  }

  @override
  void dispose() {
    _profileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProfileScope(
      controller: _profileController,
      child: MaterialApp(
        title: 'PetBem',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        locale: const Locale('pt', 'BR'),
        supportedLocales: const [Locale('pt', 'BR')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: const SplashPage(),
      ),
    );
  }
}
