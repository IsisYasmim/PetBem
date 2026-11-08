
import 'package:flutter/material.dart';

import '../../features/home/presentation/pages/home_page.dart';
import '../common/widgets/coming_soon_view.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  static const Color primaryColor = Color(0xFFFF705D);
  static const Color secondaryColor = Color(0xFF40C4C8);

  static const List<Widget> _tabs = [
    HomePage(),
    ComingSoonView(
      title: 'Explorar',
      icon: Icons.explore_outlined,
    ),
    ComingSoonView(
      title: 'Favoritos',
      icon: Icons.favorite_outline,
    ),
    ProfilePage(),
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _onDestinationSelected(0);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _tabs,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onDestinationSelected,
          backgroundColor: Colors.white,
          indicatorColor: secondaryColor.withValues(alpha: 0.18),
          elevation: 3,
          height: 70,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(
                Icons.home_outlined,
                color: Colors.black54,
              ),
              selectedIcon: Icon(
                Icons.home_rounded,
                color: primaryColor,
              ),
              label: 'Início',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.explore_outlined,
                color: Colors.black54,
              ),
              selectedIcon: Icon(
                Icons.explore_rounded,
                color: primaryColor,
              ),
              label: 'Explorar',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.favorite_outline,
                color: Colors.black54,
              ),
              selectedIcon: Icon(
                Icons.favorite_rounded,
                color: primaryColor,
              ),
              label: 'Favoritos',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.person_outline,
                color: Colors.black54,
              ),
              selectedIcon: Icon(
                Icons.person_rounded,
                color: primaryColor,
              ),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
