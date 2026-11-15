import 'package:flutter_test/flutter_test.dart';
import 'package:petbem/features/products/domain/entities/pet_type.dart';
import 'package:petbem/features/profile/data/user_profile_json.dart';
import 'package:petbem/features/profile/domain/entities/pet.dart';
import 'package:petbem/features/profile/domain/entities/user_profile.dart';

void main() {
  const ana = UserProfile(
    name: 'Ana',
    pets: [Pet(id: '1', name: 'Luna', type: PetType.dog)],
  );

  test('ida e volta', () {
    expect(userProfileFromJson(ana.toJson()), ana);
  });

  test('lê o formato gravado pela versão 1 do app', () {
    const version1 = {
      'schema_version': 1,
      'name': 'Ana',
      'pets': [
        {'id': '1', 'name': 'Luna', 'type': 'dog'},
      ],
    };

    expect(userProfileFromJson(version1), ana);
  });

  test('ignora pet sem nome, espécie desconhecida e campos ausentes', () {
    final profile = userProfileFromJson({
      'name': '  ',
      'pets': [
        {'name': '   ', 'type': 'dog'},
        {'name': 'Thor', 'type': 'dinossauro'},
        {'name': 'Mia', 'type': 'cat'},
        'não é um pet',
      ],
    });

    expect(profile.name, isNull);
    expect(profile.pets, [
      const Pet(id: 'pet-2-cat', name: 'Mia', type: PetType.cat),
    ]);
  });
}
