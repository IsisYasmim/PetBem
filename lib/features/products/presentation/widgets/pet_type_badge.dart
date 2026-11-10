import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/pet_type.dart';

/// Para qual pet é o produto ("Cães", "Gatos"...): coral claro com patinha.
/// Cor e ícone diferentes do ProductTagBadge, para os dois não se confundirem.
class PetTypeBadge extends StatelessWidget {
  const PetTypeBadge({super.key, required this.petType});

  final PetType petType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.coral.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.pets, size: 14, color: AppColors.ink),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              petType.label,
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
