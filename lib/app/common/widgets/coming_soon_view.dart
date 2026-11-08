
import 'package:flutter/material.dart';

class ComingSoonView extends StatelessWidget {
  const ComingSoonView({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  static const Color primaryColor = Color(0xFFFF705D);
  static const Color secondaryColor = Color(0xFF40C4C8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: secondaryColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 55,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                '$title em breve!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Estamos preparando novidades para você '
                'e seu melhor amigo. Em breve teremos '
                'mais funcionalidades disponíveis!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),
              const Icon(
                Icons.pets_rounded,
                color: secondaryColor,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
