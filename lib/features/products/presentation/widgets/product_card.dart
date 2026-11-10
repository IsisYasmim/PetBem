import 'package:flutter/material.dart';

import '../../../../app/common/formatters.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/product.dart';
import '../product_category_icon.dart';
import 'pet_type_badge.dart';
import 'product_tag_badge.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.onTap});

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MergeSemantics(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProductThumbnail(product: product),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.ink,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        product.category.label,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.ink.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        formatPrice(product.priceInCents),
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.ink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.xs,
                        runSpacing: AppSpacing.xs,
                        children: [
                          for (final petType in product.petTypes)
                            PetTypeBadge(petType: petType),
                          for (final tag in product.tags)
                            ProductTagBadge(tag: tag),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 18,
                      color: AppColors.coral,
                      semanticLabel: 'Nota',
                    ),
                    const SizedBox(width: 2),
                    Text(
                      formatDecimal(product.rating),
                      style: textTheme.labelLarge?.copyWith(
                        color: AppColors.ink,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Foto do produto, quando houver; senão, o ícone da categoria.
class _ProductThumbnail extends StatelessWidget {
  const _ProductThumbnail({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final imagePath = product.imagePath;
    final fallback = Icon(product.category.icon, color: AppColors.ink);

    return Container(
      width: 56,
      height: 56,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.teal.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: imagePath == null
          ? fallback
          : Image.asset(
              imagePath,
              fit: BoxFit.cover,
              excludeFromSemantics: true,
              errorBuilder: (_, _, _) => fallback,
            ),
    );
  }
}
