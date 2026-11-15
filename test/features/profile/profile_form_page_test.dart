import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petbem/features/products/domain/entities/pet_type.dart';
import 'package:petbem/features/profile/domain/entities/pet.dart';
import 'package:petbem/features/profile/domain/entities/user_profile.dart';
import 'package:petbem/features/profile/presentation/pages/profile_form_page.dart';

import '../../support/memory_profile_repository.dart';
import '../../support/pump_app.dart';

Future<void> _back(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Voltar'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('salvar começa desativado e exige um pet com nome', (
    tester,
  ) async {
    final repository = MemoryProfileRepository();
    await pumpWithProfile(
      tester,
      const ProfileFormPage(),
      repository: repository,
    );

    final save = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Salvar perfil'),
    );
    expect(save.onPressed, isNull);
    expect(find.text('O que você precisa evitar?'), findsNothing);

    await tester.enterText(find.byType(TextFormField), 'A');
    await tester.pump();
    await tester.tap(find.text('Salvar perfil'));
    await tester.pumpAndSettle();

    expect(find.text('Use pelo menos 2 letras.'), findsOne);
    expect(find.text('Cadastre pelo menos um pet.'), findsOne);
    expect(repository.saveCalls, 0);
  });

  testWidgets('salva o nome e o pet e volta', (tester) async {
    final repository = MemoryProfileRepository();
    await pumpWithProfile(
      tester,
      const PushButtonHost(page: ProfileFormPage()),
      repository: repository,
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '  Ana  ');
    await tester.tap(find.text('Adicionar pet'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).last, 'Luna');
    await tester.ensureVisible(find.text('Salvar perfil'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar perfil'));
    await tester.pumpAndSettle();

    expect(find.text('Perfil salvo'), findsOne);
    expect(find.byType(ProfileFormPage), findsNothing);
    expect(repository.stored.name, 'Ana');
    expect(repository.stored.pets.single.name, 'Luna');
    expect(repository.stored.pets.single.type, PetType.dog);
  });

  testWidgets('voltar com alterações pergunta antes de descartar', (
    tester,
  ) async {
    final repository = MemoryProfileRepository();
    await pumpWithProfile(
      tester,
      const PushButtonHost(page: ProfileFormPage()),
      repository: repository,
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Ana');
    await tester.pump();
    await _back(tester);

    expect(find.text('Descartar alterações?'), findsOne);
    await tester.tap(find.text('Continuar editando'));
    await tester.pumpAndSettle();
    expect(find.byType(ProfileFormPage), findsOne);

    await _back(tester);
    await tester.tap(find.text('Descartar'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileFormPage), findsNothing);
    expect(repository.saveCalls, 0);
  });

  testWidgets('abre preenchido com o perfil atual', (tester) async {
    const profile = UserProfile(
      name: 'Ana',
      pets: [Pet(id: '1', name: 'Luna', type: PetType.cat)],
    );
    await pumpWithProfile(
      tester,
      const ProfileFormPage(),
      repository: MemoryProfileRepository(stored: profile),
    );

    expect(find.text('Ana'), findsOne);
    expect(find.text('Luna'), findsOne);
    expect(find.text('Gato'), findsWidgets);
  });
}
