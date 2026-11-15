import 'package:flutter/material.dart';

import '../../../../app/common/widgets/status_message.dart';
import '../../../../app/theme/app_layout.dart';
import '../../../../app/theme/app_spacing.dart';
import '../profile_scope.dart';
import '../widgets/profile_privacy_note.dart';
import '../widgets/profile_summary_card.dart';
import 'profile_form_page.dart';

/// Leitura do perfil da pessoa e dos pets. A edição fica no formulário.
class PersonalDataPage extends StatelessWidget {
  const PersonalDataPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const PersonalDataPage());
  }

  void _openForm(BuildContext context) {
    Navigator.of(context).push(ProfileFormPage.route());
  }

  @override
  Widget build(BuildContext context) {
    final controller = ProfileScope.of(context);
    final profile = controller.profile;
    final horizontalPadding = AppLayout.horizontalPadding(
      MediaQuery.sizeOf(context).width,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Dados pessoais')),
      body: !controller.isLoaded
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                AppSpacing.sm,
                horizontalPadding,
                AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (profile.isComplete)
                    ProfileSummaryCard(
                      profile: profile,
                      onEdit: () => _openForm(context),
                    )
                  else
                    StatusMessage(
                      icon: Icons.pets_outlined,
                      message:
                          'Cadastre você e seus pets para ver primeiro '
                          'os produtos certos para eles.',
                      actionLabel: 'Completar perfil',
                      onAction: () => _openForm(context),
                    ),
                  const SizedBox(height: AppSpacing.lg),
                  const ProfilePrivacyNote(),
                ],
              ),
            ),
    );
  }
}
