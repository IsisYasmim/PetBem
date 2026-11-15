import '../../products/domain/entities/product.dart';
import 'entities/user_profile.dart';

/// O produto serve para algum pet cadastrado.
///
/// Perfil vazio não combina com ninguém: um selo em tudo não diria nada.
/// Um produto serve se a espécie de pelo menos um pet está entre as dele.
bool matchesProfile(Product product, UserProfile profile) {
  if (!profile.isComplete) {
    return false;
  }
  final types = {for (final pet in profile.pets) pet.type};
  return product.petTypes.any(types.contains);
}

/// Quem combina vem primeiro. Dentro de cada grupo, a ordem original fica.
List<Product> sortByProfile(List<Product> products, UserProfile profile) {
  return [
    ...products.where((product) => matchesProfile(product, profile)),
    ...products.where((product) => !matchesProfile(product, profile)),
  ];
}
