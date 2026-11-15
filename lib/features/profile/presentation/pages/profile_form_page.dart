import 'package:flutter/material.dart';

import '../../../../app/common/widgets/section_header.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_layout.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/entities/pet.dart';
import '../../domain/entities/user_profile.dart';
import '../profile_scope.dart';
import '../widgets/discard_changes_dialog.dart';
import '../widgets/pets_field.dart';
import '../widgets/profile_privacy_note.dart';

class ProfileFormPage extends StatefulWidget {
  const ProfileFormPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const ProfileFormPage());
  }

  @override
  State<ProfileFormPage> createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final UserProfile _original;
  late UserProfile _draft;
  late final TextEditingController _nameController;
  bool _submitted = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _original = ProfileScope.read(context).profile;
    _draft = _original;
    _nameController = TextEditingController(text: _original.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _hasChanges => _draft != _original;

  void _onNameChanged(String text) {
    final name = text.trim();
    setState(() {
      _draft = name.isEmpty
          ? _draft.copyWith(clearName: true)
          : _draft.copyWith(name: name);
    });
  }

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isNotEmpty && name.length < 2) {
      return 'Use pelo menos 2 letras.';
    }
    return null;
  }

  void _onPetsChanged(List<Pet> pets) {
    setState(() => _draft = _draft.copyWith(pets: pets));
  }

  Future<void> _save() async {
    if (_isSaving) {
      return;
    }
    setState(() => _submitted = true);
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);
    final messenger = ScaffoldMessenger.of(context);
    final controller = ProfileScope.read(context);

    try {
      await controller.save(_draft);
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() => _isSaving = false);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Não foi possível salvar. Tente novamente.'),
          ),
        );
      return;
    }

    if (!mounted) {
      return;
    }
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Perfil salvo')));
    Navigator.of(context).pop();
  }

  Future<void> _onPopInvoked(bool didPop, Object? result) async {
    if (didPop) {
      return;
    }
    final discard = await confirmDiscardChanges(context);
    if (discard && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = AppLayout.horizontalPadding(
      MediaQuery.sizeOf(context).width,
    );
    final helperStyle = Theme.of(context).textTheme.bodySmall
        ?.copyWith(color: AppColors.ink.withValues(alpha: 0.8));

    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: _onPopInvoked,
      child: Scaffold(
        appBar: AppBar(title: const Text('Dados pessoais')),
        body: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                autovalidateMode: _submitted
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    AppSpacing.sm,
                    horizontalPadding,
                    AppSpacing.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SectionHeader(title: 'Como podemos te chamar?'),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nome (opcional)',
                          helperText: 'Aparece só na saudação do app.',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.givenName],
                        maxLength: 30,
                        validator: _validateName,
                        onChanged: _onNameChanged,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).unfocus(),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      const SectionHeader(title: 'Seus pets'),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Os produtos para eles aparecem primeiro na Home.',
                        style: helperStyle,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      PetsField(
                        initialPets: _original.pets,
                        onChanged: _onPetsChanged,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      const ProfilePrivacyNote(),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  AppSpacing.sm,
                  horizontalPadding,
                  AppSpacing.md,
                ),
                child: FilledButton(
                  onPressed: _hasChanges && !_isSaving ? _save : null,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: _isSaving
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            semanticsLabel: 'Salvando',
                          ),
                        )
                      : const Text('Salvar perfil'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
