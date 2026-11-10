import '../domain/pet_type.dart';
import '../domain/product.dart';
import '../domain/product_category.dart';
import '../domain/product_repository.dart';
import '../domain/product_tag.dart';

class FakeProductRepository implements ProductRepository {
  const FakeProductRepository({
    this.delay = const Duration(milliseconds: 800),
  });

  final Duration delay;

  // Já em ordem de mais vendido.
  static const List<Product> _bestSellers = [
    Product(
      id: '1',
      name: 'Ração Natural Cães Adultos 10 kg',
      category: ProductCategory.food,
      petTypes: {PetType.dog},
      priceInCents: 14990,
      rating: 4.8,
      tags: {ProductTag.natural, ProductTag.noArtificialColors},
    ),
    Product(
      id: '2',
      name: 'Shampoo Neutro Pele Sensível',
      category: ProductCategory.hygiene,
      petTypes: {PetType.dog, PetType.cat},
      priceInCents: 3990,
      rating: 4.9,
      tags: {ProductTag.hypoallergenic, ProductTag.crueltyFree},
    ),
    Product(
      id: '3',
      name: 'Petisco Cremoso de Atum',
      category: ProductCategory.treats,
      petTypes: {PetType.cat},
      priceInCents: 1290,
      rating: 4.7,
      tags: {ProductTag.noArtificialColors},
    ),
    Product(
      id: '4',
      name: 'Bolinha Mordedora de Borracha',
      category: ProductCategory.toys,
      petTypes: {PetType.dog},
      priceInCents: 3490,
      rating: 4.6,
      tags: {ProductTag.nonToxic, ProductTag.sustainable},
    ),
    Product(
      id: '5',
      name: 'Roda de Exercício Silenciosa',
      category: ProductCategory.accessories,
      petTypes: {PetType.hamster},
      priceInCents: 5990,
      rating: 4.5,
      tags: {ProductTag.nonToxic},
    ),
    Product(
      id: '6',
      name: 'Mistura de Sementes para Calopsitas 500 g',
      category: ProductCategory.food,
      petTypes: {PetType.bird},
      priceInCents: 2490,
      rating: 4.4,
      tags: {ProductTag.natural},
    ),
  ];

  @override
  Future<List<Product>> fetchBestSellers() async {
    await Future<void>.delayed(delay);
    return _bestSellers;
  }
}
