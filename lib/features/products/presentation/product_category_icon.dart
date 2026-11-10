import 'package:flutter/material.dart';

import '../domain/product_category.dart';

extension ProductCategoryIcon on ProductCategory {
  IconData get icon => switch (this) {
    ProductCategory.food => Icons.rice_bowl_outlined,
    ProductCategory.treats => Icons.cookie_outlined,
    ProductCategory.toys => Icons.sports_baseball_outlined,
    ProductCategory.accessories => Icons.pets_outlined,
    ProductCategory.hygiene => Icons.bathtub_outlined,
  };
}
