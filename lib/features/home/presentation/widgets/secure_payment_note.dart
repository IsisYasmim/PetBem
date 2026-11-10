import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

/// Cumpre a promessa "Pagamento Seguro" do onboarding.
///
/// É uma garantia, não uma ação: por isso só informa e não é tocável.
class SecurePaymentNote extends StatelessWidget {
  const SecurePaymentNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: Row(
        children: [
          const Icon(Icons.lock_outline, size: 18, color: AppColors.ink),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Pagamento seguro e checkout simplificado',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.ink.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
