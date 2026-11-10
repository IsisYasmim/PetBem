import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../products/domain/product_category.dart';
import '../../../products/presentation/product_category_icon.dart';

/// Atalhos de categoria em uma fileira que rola para o lado.
///
/// Com 5 categorias, dividir a largura em colunas iguais cortava os rótulos
/// em telas pequenas e com fonte ampliada. Aqui cada atalho tem a largura
/// do seu rótulo, que nunca é cortado.
class CategoryShortcuts extends StatelessWidget {
  const CategoryShortcuts({super.key, required this.onSelected});

  final ValueChanged<ProductCategory> onSelected;

  /// Partes fixas do atalho: padding (8 + 8) + círculo (56) + espaço (8).
  static const double _tileFixedHeight =
      AppSpacing.sm + _circleSize + AppSpacing.sm + AppSpacing.sm;

  static const double _circleSize = 56;

  @override
  Widget build(BuildContext context) {
    // Uma ListView horizontal precisa de altura definida. Ela é calculada
    // com a escala de fonte do usuário: uma altura fixa daria overflow
    // com a fonte ampliada.
    final labelStyle = Theme.of(context).textTheme.labelMedium!;
    final labelHeight = MediaQuery.textScalerOf(
      context,
    ).scale(labelStyle.fontSize! * (labelStyle.height ?? 1.2));

    return SizedBox(
      // +2: folga para o arredondamento da altura da linha.
      height: _tileFixedHeight + labelHeight + 2,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: ProductCategory.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final category = ProductCategory.values[index];
          return _CategoryTile(
            category: category,
            onTap: () => onSelected(category),
          );
        },
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.onTap});

  final ProductCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 72),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: CategoryShortcuts._circleSize,
                height: CategoryShortcuts._circleSize,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(category.icon, color: AppColors.ink),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                category.label,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: AppColors.ink),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
