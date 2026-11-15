import '../../products/domain/entities/pet_type.dart';
import '../domain/entities/pet.dart';
import '../domain/entities/user_profile.dart';

extension UserProfileJson on UserProfile {
  Map<String, Object?> toJson() => {
    'name': name,
    'pets': [
      for (final pet in pets)
        {'id': pet.id, 'name': pet.name, 'type': pet.type.name},
    ],
  };
}

UserProfile userProfileFromJson(Map<String, Object?> json) {
  final types = PetType.values.asNameMap();
  final pets = <Pet>[];

  if (json['pets'] case final List<Object?> values) {
    for (var i = 0; i < values.length; i++) {
      final pet = _petFromJson(values[i], i, types);
      if (pet != null) {
        pets.add(pet);
      }
    }
  }

  return UserProfile(
    name: switch (json['name']) {
      final String name when name.trim().isNotEmpty => name,
      _ => null,
    },
    pets: pets,
  );
}

Pet? _petFromJson(Object? value, int index, Map<String, PetType> types) {
  if (value is! Map) {
    return null;
  }
  final name = value['name'];
  final typeName = value['type'];
  final type = typeName is String ? types[typeName] : null;
  if (name is! String || name.trim().isEmpty || type == null) {
    return null;
  }
  final id = value['id'];
  return Pet(
    id: id is String && id.trim().isNotEmpty ? id : 'pet-$index-${type.name}',
    name: name.trim(),
    type: type,
  );
}
