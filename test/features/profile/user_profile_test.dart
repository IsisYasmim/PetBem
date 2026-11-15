import 'package:flutter_test/flutter_test.dart';
import 'package:petbem/features/products/domain/entities/pet_type.dart';
import 'package:petbem/features/profile/domain/entities/pet.dart';
import 'package:petbem/features/profile/domain/entities/user_profile.dart';

void main() {
  final luna = Pet(id: '1', name: 'Luna', type: PetType.dog);

  test('vazio não está completo', () {
    expect(UserProfile.empty.isComplete, isFalse);
  });

  test('fica completo com um pet, mesmo sem nome da pessoa', () {
    final profile = UserProfile(pets: [luna]);
    expect(profile.isComplete, isTrue);
  });

  test('mesmos valores em objetos diferentes são iguais', () {
    final a = UserProfile(name: 'Ana', pets: [luna]);
    final b = UserProfile(
      name: 'Ana',
      pets: [const Pet(id: '1', name: 'Luna', type: PetType.dog)],
    );

    expect(identical(a, b), isFalse);
    expect(a, b);
  });

  test('copyWith apaga o nome', () {
    final profile = UserProfile(name: 'Ana', pets: [luna]);
    expect(profile.copyWith(clearName: true).name, isNull);
    expect(profile.copyWith(clearName: true).pets, [luna]);
  });
}
