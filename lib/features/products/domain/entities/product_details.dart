import 'portion_guide.dart';
import 'product_care.dart';
import 'product_photo.dart';

class ProductDetails {
  const ProductDetails({
    required this.productId,
    required this.brand,
    required this.description,
    required this.usage,
    required this.netContent,
    required this.stockQuantity,
    required this.cares,
    this.portions = const [],
    this.photos = const [],
  });

  /// Abaixo deste número, e ainda acima de zero, o estoque é "últimas unidades".
  static const int lowStockThreshold = 5;

  final String productId;
  final String brand;
  final String description;
  final String usage;

  /// Conteúdo líquido como está na embalagem: "10 kg", "300 ml", "8 cm".
  final String netContent;

  final int stockQuantity;
  final Set<ProductCare> cares;
  final List<PortionGuide> portions;
  final List<ProductPhoto> photos;

  bool get isOutOfStock => stockQuantity <= 0;

  bool get isLowStock => stockQuantity > 0 && stockQuantity < lowStockThreshold;

  PortionGuide? portionFor(double weightKg) {
    for (final portion in portions) {
      if (portion.contains(weightKg)) {
        return portion;
      }
    }
    return null;
  }
}
