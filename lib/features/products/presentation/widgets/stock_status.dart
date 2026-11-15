import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/entities/product_details.dart';

class StockStatus extends StatelessWidget {
  const StockStatus({super.key, required this.details});

  final ProductDetails details;

  @override
  Widget build(BuildContext context) {
    final label = _label(details);
    final inStock = !details.isOutOfStock && !details.isLowStock;

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: inStock
              ? AppColors.teal.withValues(alpha: 0.18)
              : AppColors.ink.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_icon(details), size: 18, color: AppColors.ink),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _label(ProductDetails details) {
    if (details.isOutOfStock) {
      return 'Esgotado';
    }
    if (details.isLowStock) {
      final quantity = details.stockQuantity;
      final verb = quantity == 1 ? 'resta' : 'restam';
      return 'Últimas unidades · $verb $quantity';
    }
    return 'Em estoque · ${details.stockQuantity} unidades';
  }

  static IconData _icon(ProductDetails details) {
    if (details.isOutOfStock) {
      return Icons.do_not_disturb_on_outlined;
    }
    if (details.isLowStock) {
      return Icons.hourglass_bottom;
    }
    return Icons.inventory_2_outlined;
  }
}
