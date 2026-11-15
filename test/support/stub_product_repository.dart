import 'package:petbem/features/products/domain/entities/pet_type.dart';
import 'package:petbem/features/products/domain/entities/portion_guide.dart';
import 'package:petbem/features/products/domain/entities/product.dart';
import 'package:petbem/features/products/domain/entities/product_care.dart';
import 'package:petbem/features/products/domain/entities/product_category.dart';
import 'package:petbem/features/products/domain/entities/product_details.dart';
import 'package:petbem/features/products/domain/entities/product_photo.dart';
import 'package:petbem/features/products/domain/entities/product_tag.dart';
import 'package:petbem/features/products/domain/repositories/product_repository.dart';

class StubProductRepository implements ProductRepository {
  StubProductRepository({
    this.bestSellerResults = const [],
    this.detailsResults = const [],
  });

  final List<Future<List<Product>> Function()> bestSellerResults;
  final List<Future<ProductDetails?> Function()> detailsResults;
  int bestSellerCalls = 0;
  int detailsCalls = 0;

  @override
  Future<List<Product>> fetchBestSellers() =>
      bestSellerResults[bestSellerCalls++]();

  @override
  Future<ProductDetails?> fetchDetails(String productId) =>
      detailsResults[detailsCalls++]();
}

const testProduct = Product(
  id: '1',
  name: 'Ração Teste',
  category: ProductCategory.food,
  petTypes: {PetType.dog},
  priceInCents: 14990,
  rating: 4.8,
  tags: {ProductTag.natural},
);

const testProductDetails = ProductDetails(
  productId: '1',
  brand: 'NatuPet',
  description: 'Uma ração de teste.',
  usage: 'Divida em duas refeições.',
  netContent: '10 kg',
  stockQuantity: 12,
  cares: {ProductCare.ingredientList},
  portions: [
    PortionGuide(minWeightKg: 0.0, maxWeightKg: 5.0, gramsPerDay: 90),
    PortionGuide(minWeightKg: 5.0, gramsPerDay: 180),
  ],
  photos: [
    ProductPhoto(
      source: 'assets/images/products/racao_natural/photo_1.jpg',
      description: 'Pacote da ração de teste',
    ),
    ProductPhoto(
      source: 'assets/images/products/racao_natural/photo_2.jpg',
      description: 'Grãos da ração de teste',
    ),
  ],
);
