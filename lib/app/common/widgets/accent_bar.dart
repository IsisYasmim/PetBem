import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';

/// Barrinha turquesa sob os títulos: a assinatura visual do PetBem.
/// É decoração; o significado fica sempre no texto.
class AccentBar extends StatelessWidget {
  const AccentBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.teal,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
    );
  }
}
