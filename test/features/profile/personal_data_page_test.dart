import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petbem/features/products/domain/entities/pet_type.dart';
import 'package:petbem/features/profile/domain/entities/pet.dart';
import 'package:petbem/features/profile/domain/entities/user_profile.dart';
import 'package:petbem/features/profile/presentation/pages/personal_data_page.dart';
import 'package:petbem/features/profile/presentation/pages/profile_form_page.dart';
import 'package:petbem/features/profile/presentation/pages/profile_page.dart';

import '../../support/memory_profile_repository.dart';
import '../../support/pump_app.dart';

void main() {
  testWidgets('dados pessoais vazio convida a completar', (tester) async {
    await pumpWithProfile(tester, const PersonalDataPage());

    expect(
      find.text(
        'Cadastre você e seus pets para ver primeiro '
        'os produtos certos para eles.',
      ),
      findsOne,
    );
    expect(find.text('O que você precisa evitar?'), findsNothing);
  });

  testWidgets('perfil completo mostra a pessoa e os pets', (tester) async {
    const profile = UserProfile(
      name: 'Ana',
      pets: [Pet(id: '1', name: 'Luna', type: PetType.dog)],
    );
    await pumpWithProfile(
      tester,
      const PersonalDataPage(),
      repository: MemoryProfileRepository(stored: profile),
    );

    expect(find.text('Ana'), findsWidgets);
    expect(find.text('Luna · Cão'), findsOne);
    expect(find.text('Editar perfil'), findsOne);
  });

  testWidgets('completar o perfil troca o convite pelo resumo', (tester) async {
    final repository = MemoryProfileRepository();
    await pumpWithProfile(
      tester,
      const PersonalDataPage(),
      repository: repository,
    );

    await tester.tap(find.text('Completar perfil'));
    await tester.pumpAndSettle();
    expect(find.byType(ProfileFormPage), findsOne);

    await tester.tap(find.text('Adicionar pet'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).last, 'Luna');
    await tester.ensureVisible(find.text('Salvar perfil'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar perfil'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileFormPage), findsNothing);
    expect(find.text('Luna · Cão'), findsOne);
    expect(repository.loadCalls, 1);
  });

  testWidgets('a aba Perfil abre os dados pessoais e não tem Meus pets', (
    tester,
  ) async {
    await pumpWithProfile(tester, const ProfilePage());

    expect(find.text('Meus pets'), findsNothing);
    expect(find.text('Você e seus pets'), findsOne);

    await tester.tap(find.text('Dados pessoais'));
    await tester.pumpAndSettle();

    expect(find.byType(PersonalDataPage), findsOne);
    expect(find.text('Completar perfil'), findsOne);
  });
}
