import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/product_tag.dart';

/// Atributo do produto ("Natural", "Atóxico"...): turquesa claro com check.
class ProductTagBadge extends StatelessWidget {
  const ProductTagBadge({super.key, required this.tag});

  final ProductTag tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.teal.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 14, color: AppColors.ink),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              tag.label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.ink,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
