import 'package:flutter/material.dart';

import '../../../../app/common/widgets/source_image.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../domain/entities/product.dart';
import '../product_category_icon.dart';
import 'category_icon_tile.dart';

class ProductLogo extends StatelessWidget {
  const ProductLogo({super.key, required this.product, this.size = 56});

  final Product product;
  final double size;

  @override
  Widget build(BuildContext context) {
    final imagePath = product.imagePath;
    if (imagePath == null) {
      return CategoryIconTile(category: product.category, size: size);
    }

    final padding = size * 0.1;
    final fallback = Icon(
      product.category.icon,
      color: AppColors.ink,
      size: size * 3 / 7,
    );

    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.ink.withValues(alpha: 0.12)),
      ),
      child: SourceImage(
        source: imagePath,
        displayWidth: size - padding * 2,
        fit: BoxFit.contain,
        fallback: fallback,
      ),
    );
  }
}
