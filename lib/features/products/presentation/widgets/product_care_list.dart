import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/entities/product_care.dart';
import '../product_care_icon.dart';

class ProductCareList extends StatelessWidget {
  const ProductCareList({super.key, required this.cares});

  final Set<ProductCare> cares;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyStyle = textTheme.bodyMedium?.copyWith(color: AppColors.ink);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (cares.isEmpty)
          Text(
            'O fabricante ainda não informou os cuidados deste produto.',
            style: bodyStyle,
          ),
        for (final care in ProductCare.values)
          if (cares.contains(care))
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(care.icon, size: 20, color: AppColors.ink),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text(care.label, style: bodyStyle)),
                ],
              ),
            ),
        const Divider(height: AppSpacing.lg),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info_outline,
              size: 18,
              color: AppColors.ink.withValues(alpha: 0.7),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'Informações fornecidas pelo fabricante. Em caso de dúvida, '
                'confirme na embalagem ou com um veterinário antes de usar.',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.ink.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
