import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';

/// O único destaque escuro da Home, com uma única ação.
///
/// A Home mostra um convite por vez: primeiro [ProfilePromptCard.pet];
/// depois que o pet for cadastrado, [ProfilePromptCard.profile].
class ProfilePromptCard extends StatelessWidget {
  const ProfilePromptCard.pet({super.key, required this.onPressed})
    : icon = Icons.pets,
      title = 'Cadastre seu pet',
      description =
          'Conte quem é o seu melhor amigo e veja primeiro '
          'os produtos certos para ele.',
      actionLabel = 'Cadastrar pet';

  const ProfilePromptCard.profile({super.key, required this.onPressed})
    : icon = Icons.person_outline,
      title = 'Complete seu perfil',
      description =
          'Salve seu endereço e sua forma de pagamento '
          'e finalize suas compras mais rápido.',
      actionLabel = 'Completar perfil';

  final IconData icon;
  final String title;
  final String description;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.coral),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            description,
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Exceção local ao tema: botão coral com texto ink (5,9:1).
          FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.coral,
              foregroundColor: AppColors.ink,
              minimumSize: const Size(0, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
            child: Text(
              actionLabel,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
