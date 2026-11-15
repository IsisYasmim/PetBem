import 'package:flutter/material.dart';

import '../../../../app/common/formatters.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/entities/product.dart';
import 'pet_type_badge.dart';
import 'product_tag_badge.dart';

class ProductSummary extends StatelessWidget {
  const ProductSummary({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            product.name,
            style: textTheme.headlineSmall?.copyWith(
              color: AppColors.ink,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          product.category.label,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.ink.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          formatPrice(product.priceInCents),
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.ink,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        MergeSemantics(
          child: Row(
            children: [
              const Icon(
                Icons.star_rounded,
                size: 20,
                color: AppColors.coral,
                semanticLabel: 'Nota',
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                formatDecimal(product.rating),
                style: textTheme.titleSmall?.copyWith(
                  color: AppColors.ink,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final petType in product.petTypes)
              PetTypeBadge(petType: petType),
            for (final tag in product.tags) ProductTagBadge(tag: tag),
          ],
        ),
      ],
    );
  }
}
