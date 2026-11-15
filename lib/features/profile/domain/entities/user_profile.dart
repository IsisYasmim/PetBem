import 'pet.dart';

/// Quem usa o app e os pets que moram com essa pessoa.
///
/// O nome só muda a saudação. O que muda a Home é a lista de pets.
class UserProfile {
  const UserProfile({this.name, this.pets = const []});

  static const UserProfile empty = UserProfile();

  final String? name;
  final List<Pet> pets;

  /// Completo quando há pelo menos um pet: é isso que a Home sabe usar.
  bool get isComplete => pets.isNotEmpty;

  UserProfile copyWith({
    String? name,
    bool clearName = false,
    List<Pet>? pets,
  }) {
    return UserProfile(
      name: clearName ? null : (name ?? this.name),
      pets: pets ?? this.pets,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UserProfile &&
        other.name == name &&
        _samePets(other.pets, pets);
  }

  @override
  int get hashCode => Object.hash(name, Object.hashAll(pets));
}

bool _samePets(List<Pet> a, List<Pet> b) {
  if (a.length != b.length) {
    return false;
  }
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) {
      return false;
    }
  }
  return true;
}
