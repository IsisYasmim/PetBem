import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../products/domain/entities/pet_type.dart';
import '../../domain/entities/pet.dart';
import '../pet_type_labels.dart';

/// Lista de pets do formulário. Pelo menos um, cada um com nome.
class PetsField extends StatefulWidget {
  const PetsField({
    super.key,
    required this.initialPets,
    required this.onChanged,
  });

  final List<Pet> initialPets;
  final ValueChanged<List<Pet>> onChanged;

  @override
  State<PetsField> createState() => _PetsFieldState();
}

class _PetsFieldState extends State<PetsField> {
  final _fieldKey = GlobalKey<FormFieldState<List<Pet>>>();
  final _controllers = <String, TextEditingController>{};
  late List<Pet> _pets;
  var _nextId = 0;

  @override
  void initState() {
    super.initState();
    _pets = [...widget.initialPets];
    for (final pet in _pets) {
      _controllers[pet.id] = TextEditingController(text: pet.name);
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String _newId() => 'new-${_nextId++}';

  void _emit() {
    final pets = [for (final pet in _pets) pet];
    widget.onChanged(pets);
    _fieldKey.currentState?.didChange(pets);
  }

  void _addPet() {
    final pet = Pet(id: _newId(), name: '', type: PetType.dog);
    setState(() {
      _pets = [..._pets, pet];
      _controllers[pet.id] = TextEditingController();
    });
    _emit();
  }

  void _removePet(Pet pet) {
    _controllers.remove(pet.id)?.dispose();
    setState(() {
      _pets = [
        for (final item in _pets)
          if (item.id != pet.id) item,
      ];
    });
    _emit();
  }

  void _onNameChanged(Pet pet, String text) {
    final name = text.trim();
    final index = _pets.indexWhere((item) => item.id == pet.id);
    if (index == -1 || _pets[index].name == name) {
      return;
    }
    setState(() {
      final next = [..._pets];
      next[index] = _pets[index].copyWith(name: name);
      _pets = next;
    });
    _emit();
  }

  void _onTypeChanged(Pet pet, PetType? type) {
    if (type == null || type == pet.type) {
      return;
    }
    final index = _pets.indexWhere((item) => item.id == pet.id);
    if (index == -1) {
      return;
    }
    setState(() {
      final next = [..._pets];
      next[index] = _pets[index].copyWith(type: type);
      _pets = next;
    });
    _emit();
  }

  String? _validatePetName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) {
      return 'Dê um nome ao pet.';
    }
    if (name.length < 2) {
      return 'Use pelo menos 2 letras.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<List<Pet>>(
      key: _fieldKey,
      initialValue: widget.initialPets,
      validator: (_) => _pets.isEmpty ? 'Cadastre pelo menos um pet.' : null,
      builder: (state) {
        final error = state.errorText;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final pet in _pets) ...[
              Card(
                key: ValueKey(pet.id),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _controllers[pet.id],
                        decoration: const InputDecoration(
                          labelText: 'Nome do pet',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        maxLength: 30,
                        validator: _validatePetName,
                        onChanged: (text) => _onNameChanged(pet, text),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      DropdownButtonFormField<PetType>(
                        initialValue: pet.type,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Espécie',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          for (final type in PetType.values)
                            DropdownMenuItem(
                              value: type,
                              child: Text(type.profileLabel),
                            ),
                        ],
                        onChanged: (type) => _onTypeChanged(pet, type),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => _removePet(pet),
                          child: const Text('Remover'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            OutlinedButton.icon(
              onPressed: _addPet,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.ink,
                minimumSize: const Size.fromHeight(48),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Adicionar pet'),
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Semantics(
                  liveRegion: true,
                  child: Text(
                    error,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
