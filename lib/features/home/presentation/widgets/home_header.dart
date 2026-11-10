import 'package:flutter/material.dart';

import '../../../../app/common/widgets/accent_bar.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.greeting});

  final String greeting;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting!',
          style: textTheme.headlineSmall?.copyWith(
            color: AppColors.ink,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        const AccentBar(),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'O que seu pet precisa hoje?',
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.ink.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
