import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

class ComingSoonView extends StatelessWidget {
  const ComingSoonView({super.key, required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Círculo turquesa: decoração; o ícone fica em ink.
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.teal.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 48, color: AppColors.ink),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                title,
                style: textTheme.titleLarge?.copyWith(
                  color: AppColors.ink,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Estamos preparando novidades para você e seu melhor amigo. '
                'Esta área estará disponível em breve!',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.ink.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              const Icon(Icons.pets_rounded, color: AppColors.teal, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}
