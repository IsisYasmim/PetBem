import 'package:flutter_test/flutter_test.dart';
import 'package:petbem/features/products/domain/entities/pet_type.dart';
import 'package:petbem/features/products/domain/entities/product.dart';
import 'package:petbem/features/products/domain/entities/product_category.dart';
import 'package:petbem/features/profile/domain/entities/pet.dart';
import 'package:petbem/features/profile/domain/entities/user_profile.dart';
import 'package:petbem/features/profile/domain/profile_match.dart';

Product _product(String name, Set<PetType> types) {
  return Product(
    id: name,
    name: name,
    category: ProductCategory.food,
    petTypes: types,
    priceInCents: 1000,
    rating: 4,
    tags: const {},
  );
}

void main() {
  final dogFood = _product('Ração de cão', {PetType.dog});
  final both = _product('Shampoo', {PetType.dog, PetType.cat});
  final catFood = _product('Ração de gato', {PetType.cat});
  final bird = _product('Sementes', {PetType.bird});
  final products = [catFood, dogFood, bird, both];

  final dogProfile = UserProfile(
    pets: const [Pet(id: '1', name: 'Luna', type: PetType.dog)],
  );

  test('perfil vazio não combina com ninguém e não muda a ordem', () {
    expect(matchesProfile(dogFood, UserProfile.empty), isFalse);
    expect(sortByProfile(products, UserProfile.empty), products);
  });

  test('produto de cão ou de cão e gato combina com um cão', () {
    expect(matchesProfile(dogFood, dogProfile), isTrue);
    expect(matchesProfile(both, dogProfile), isTrue);
    expect(matchesProfile(catFood, dogProfile), isFalse);
  });

  test('quem combina vem primeiro, cada grupo na ordem original', () {
    expect(sortByProfile(products, dogProfile), [dogFood, both, catFood, bird]);
  });

  test('não altera a lista recebida', () {
    final original = List.of(products);
    final sorted = sortByProfile(products, dogProfile);

    expect(products, original);
    expect(identical(sorted, products), isFalse);
  });
}
