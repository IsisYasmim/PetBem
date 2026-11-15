import 'package:flutter/material.dart';

import '../domain/entities/product_care.dart';

extension ProductCareIcon on ProductCare {
  IconData get icon => switch (this) {
    ProductCare.ingredientList => Icons.list_alt_outlined,
    ProductCare.veterinaryGuidance => Icons.medical_services_outlined,
    ProductCare.ageOnPackage => Icons.calendar_month_outlined,
    ProductCare.traceableBatch => Icons.qr_code_2_outlined,
  };
}
