import 'pet_type.dart';
import 'product_category.dart';
import 'product_tag.dart';

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.petTypes,
    required this.priceInCents,
    required this.rating,
    required this.tags,
    this.imagePath,
  });

  final String id;
  final String name;
  final ProductCategory category;

  /// Para quais pets o produto serve (um shampoo pode servir a cães e gatos).
  final Set<PetType> petTypes;

  /// Preço em centavos: R$ 149,90 é 14990. Dinheiro em inteiro evita os
  /// erros de arredondamento do double (0.1 + 0.2 != 0.3).
  final int priceInCents;

  final double rating;
  final Set<ProductTag> tags;

  /// Caminho de um asset. Quando nulo, a tela mostra o ícone da categoria.
  final String? imagePath;
}
