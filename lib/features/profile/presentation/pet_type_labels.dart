import '../../products/domain/entities/pet_type.dart';

/// No produto, a espécie aparece no plural ("Cães"). No cadastro do pet, no singular.
extension PetTypeProfileLabel on PetType {
  String get profileLabel => switch (this) {
    PetType.dog => 'Cão',
    PetType.cat => 'Gato',
    PetType.bird => 'Pássaro',
    PetType.fish => 'Peixe',
    PetType.hamster => 'Hamster',
  };
}
