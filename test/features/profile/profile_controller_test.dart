import 'package:flutter_test/flutter_test.dart';
import 'package:petbem/features/products/domain/entities/pet_type.dart';
import 'package:petbem/features/profile/domain/entities/pet.dart';
import 'package:petbem/features/profile/domain/entities/user_profile.dart';
import 'package:petbem/features/profile/presentation/profile_controller.dart';

import '../../support/memory_profile_repository.dart';

void main() {
  const ana = UserProfile(
    name: 'Ana',
    pets: [Pet(id: '1', name: 'Luna', type: PetType.dog)],
  );

  test('chamar duas vezes lê o repositório uma vez só', () async {
    final repository = MemoryProfileRepository(stored: ana);
    final controller = ProfileController(repository);
    addTearDown(controller.dispose);

    await Future.wait([controller.load(), controller.load()]);
    await controller.load();

    expect(repository.loadCalls, 1);
    expect(controller.profile, ana);
    expect(controller.isLoaded, isTrue);
  });

  test('falha na leitura abre com o perfil vazio', () async {
    final repository = MemoryProfileRepository(failOnLoad: true);
    final controller = ProfileController(repository);
    addTearDown(controller.dispose);

    await controller.load();

    expect(controller.profile, UserProfile.empty);
    expect(controller.isLoaded, isTrue);
  });

  test('falha na gravação: repassa o erro e nada muda', () async {
    final repository = MemoryProfileRepository(failOnSave: true);
    final controller = ProfileController(repository);
    addTearDown(controller.dispose);
    await controller.load();
    var notifications = 0;
    controller.addListener(() => notifications++);

    await expectLater(controller.save(ana), throwsException);

    expect(controller.profile, UserProfile.empty);
    expect(repository.stored, UserProfile.empty);
    expect(notifications, 0);
  });
}
