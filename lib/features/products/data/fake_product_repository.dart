import '../domain/entities/pet_type.dart';
import '../domain/entities/portion_guide.dart';
import '../domain/entities/product.dart';
import '../domain/entities/product_care.dart';
import '../domain/entities/product_category.dart';
import '../domain/entities/product_details.dart';
import '../domain/entities/product_photo.dart';
import '../domain/entities/product_tag.dart';
import '../domain/repositories/product_repository.dart';

class FakeProductRepository implements ProductRepository {
  const FakeProductRepository({this.delay = const Duration(milliseconds: 800)});

  final Duration delay;

  static const String _images = 'assets/images/products';

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
      imagePath: '$_images/racao_natural/image.jpg',
    ),
    Product(
      id: '2',
      name: 'Shampoo Neutro Pele Sensível',
      category: ProductCategory.hygiene,
      petTypes: {PetType.dog, PetType.cat},
      priceInCents: 3990,
      rating: 4.9,
      tags: {ProductTag.hypoallergenic, ProductTag.crueltyFree},
      imagePath: '$_images/shampoo_neutro/image.jpg',
    ),
    Product(
      id: '3',
      name: 'Petisco Cremoso de Atum',
      category: ProductCategory.treats,
      petTypes: {PetType.cat},
      priceInCents: 1290,
      rating: 4.7,
      tags: {ProductTag.noArtificialColors},
      imagePath: '$_images/petisco_atum/image.jpg',
    ),
    Product(
      id: '4',
      name: 'Bolinha Mordedora de Borracha',
      category: ProductCategory.toys,
      petTypes: {PetType.dog},
      priceInCents: 3490,
      rating: 4.6,
      tags: {ProductTag.nonToxic, ProductTag.sustainable},
      imagePath: '$_images/bolinha/image.jpg',
    ),
    Product(
      id: '5',
      name: 'Roda de Exercício Silenciosa',
      category: ProductCategory.accessories,
      petTypes: {PetType.hamster},
      priceInCents: 5990,
      rating: 4.5,
      tags: {ProductTag.nonToxic},
      imagePath: '$_images/roda_hamster/image.jpg',
    ),
    Product(
      id: '6',
      name: 'Mistura de Sementes para Calopsitas 500 g',
      category: ProductCategory.food,
      petTypes: {PetType.bird},
      priceInCents: 2490,
      rating: 4.4,
      tags: {ProductTag.natural},
      imagePath: '$_images/sementes/image.jpg',
    ),
  ];

  static final Map<String, ProductDetails> _details = {
    '1': ProductDetails(
      productId: '1',
      brand: 'NatuPet',
      description:
          'Ração de manutenção para cães adultos, com ingredientes de '
          'origem identificada e sem corantes artificiais.',
      usage:
          'Divida a porção do dia em duas refeições e deixe água fresca à '
          'vontade. Ajuste a quantidade se o cão engordar ou emagrecer.',
      netContent: '10 kg',
      stockQuantity: 24,
      cares: ProductCare.values.toSet(),
      portions: _portions(const [
        (0.0, 5.0, 90),
        (5.0, 10.0, 160),
        (10.0, 20.0, 260),
        (20.0, null, 360),
      ]),
      photos: const [
        ProductPhoto(
          source: '$_images/racao_natural/image.jpg',
          description: 'Ração natural para cães adultos',
        ),
        ProductPhoto(
          source: '$_images/racao_natural/photo_1.jpg',
          description: 'Ração natural para cães adultos',
        ),
        ProductPhoto(
          source: '$_images/racao_natural/photo_2.jpg',
          description: 'Ração natural para cães adultos',
        ),
      ],
    ),
    '2': ProductDetails(
      productId: '2',
      brand: 'Derma-calm',
      description:
          'Shampoo neutro para peles sensíveis de cães e gatos, sem '
          'perfume forte e sem corantes.',
      usage:
          'Molhe o pelo, espalhe uma pequena quantidade, massageie e '
          'enxágue bem. Use uma vez por semana, ou quando o veterinário '
          'indicar.',
      netContent: '300 ml',
      stockQuantity: 3,
      cares: {ProductCare.ingredientList, ProductCare.ageOnPackage},
      photos: const [
        ProductPhoto(
          source: '$_images/shampoo_neutro/image.jpg',
          description: 'Frasco de shampoo neutro para pele sensível',
        ),
        ProductPhoto(
          source: '$_images/shampoo_neutro/photo_1.jpg',
          description: 'Gato com espuma do shampoo sobre o pelo molhado',
        ),
        ProductPhoto(
          source: '$_images/shampoo_neutro/photo_2.jpg',
          description: 'Cachorro com espuma do shampoo sobre o pelo molhado',
        ),
      ],
    ),
    '3': ProductDetails(
      productId: '3',
      brand: 'Meow Gourmet',
      description:
          'Petisco cremoso de atum para gatos, para oferecer na mão ou '
          'sobre a refeição.',
      usage:
          'Ofereça como recompensa. Não substitui a ração. Feche a '
          'embalagem depois de aberto e guarde em local fresco.',
      netContent: '60 g',
      stockQuantity: 18,
      cares: {ProductCare.ingredientList, ProductCare.ageOnPackage},
      portions: _portions(const [
        (0.0, 4.0, 8),
        (4.0, 6.0, 12),
        (6.0, null, 15),
      ]),
      photos: const [
        ProductPhoto(
          source: '$_images/petisco_atum/image.jpg',
          description: 'Petisco na lata, com a tampa aberta e o creme visível',
        ),
        ProductPhoto(
          source: '$_images/petisco_atum/photo_1.jpg',
          description: 'Petisco servido na tigela de um gato',
        ),
      ],
    ),
    '4': ProductDetails(
      productId: '4',
      brand: 'BolaBoa',
      description:
          'Bolinha maciça de borracha atóxica, para morder e buscar. O '
          'material é pensado para durar.',
      usage:
          'Supervisione a brincadeira. Descarte a bolinha se aparecerem '
          'rachaduras ou pedaços soltos.',
      netContent: '8 cm',
      stockQuantity: 0,
      cares: {ProductCare.ageOnPackage, ProductCare.traceableBatch},
      photos: const [
        ProductPhoto(
          source: '$_images/bolinha/image.jpg',
          description: 'Bolinha mordedora de borracha',
        ),
        ProductPhoto(
          source: '$_images/bolinha/photo_1.jpg',
          description: 'Cão com a bolinha na boca',
        ),
        ProductPhoto(
          source: '$_images/bolinha/photo_2.jpg',
          description: 'Cão com a bolinha na boca',
        ),
      ],
    ),
    '5': ProductDetails(
      productId: '5',
      brand: 'RodaQuieta',
      description:
          'Roda de exercício com rolamento silencioso, para hamsters. O '
          'diâmetro cabe em gaiolas médias.',
      usage:
          'Fixe a roda na gaiola e confira se o hamster corre com as costas '
          'retas, sem curvar o corpo.',
      netContent: '18 cm',
      stockQuantity: 8,
      cares: {ProductCare.ageOnPackage},
      photos: const [
        ProductPhoto(
          source: '$_images/roda_hamster/image.jpg',
          description: 'Roda de exercício',
        ),
        ProductPhoto(
          source: '$_images/roda_hamster/photo_1.jpg',
          description: 'Roda de exercício',
        ),
      ],
    ),
    '6': ProductDetails(
      productId: '6',
      brand: 'AsaLeve',
      description:
          'Mistura de sementes para calopsitas, sem corantes. Complementa '
          'a alimentação, e não a substitui sozinha.',
      usage:
          'Ofereça cerca de 10 g por ave ao dia, em um comedouro limpo, e '
          'retire as sobras no fim do dia.',
      netContent: '500 g',
      stockQuantity: 11,
      cares: {ProductCare.ingredientList},
      photos: const [
        ProductPhoto(
          source: '$_images/sementes/image.jpg',
          description: 'Sementes em um comedouro',
        ),
        ProductPhoto(
          source: '$_images/sementes/photo_1.jpg',
          description: 'Sementes em um comedouro',
        ),
      ],
    ),
  };

  static List<PortionGuide> _portions(List<(double, double?, int)> bands) {
    return [
      for (final band in bands)
        PortionGuide(
          minWeightKg: band.$1,
          maxWeightKg: band.$2,
          gramsPerDay: band.$3,
        ),
    ];
  }

  @override
  Future<List<Product>> fetchBestSellers() async {
    await Future<void>.delayed(delay);
    return _bestSellers;
  }

  @override
  Future<ProductDetails?> fetchDetails(String productId) async {
    await Future<void>.delayed(delay);
    return _details[productId];
  }
}
