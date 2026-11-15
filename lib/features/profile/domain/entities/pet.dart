import '../../../products/domain/entities/pet_type.dart';

/// Um pet cadastrado no perfil da pessoa.
class Pet {
  const Pet({required this.id, required this.name, required this.type});

  final String id;
  final String name;
  final PetType type;

  Pet copyWith({String? name, PetType? type}) {
    return Pet(id: id, name: name ?? this.name, type: type ?? this.type);
  }

  @override
  bool operator ==(Object other) {
    return other is Pet &&
        other.id == id &&
        other.name == name &&
        other.type == type;
  }

  @override
  int get hashCode => Object.hash(id, name, type);
}
