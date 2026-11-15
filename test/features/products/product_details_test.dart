import 'package:flutter_test/flutter_test.dart';
import 'package:petbem/features/products/domain/entities/portion_guide.dart';
import 'package:petbem/features/products/domain/entities/product_care.dart';
import 'package:petbem/features/products/domain/entities/product_details.dart';

const _small = PortionGuide(
  minWeightKg: 5.0,
  maxWeightKg: 10.0,
  gramsPerDay: 160,
);

const _large = PortionGuide(minWeightKg: 10.0, gramsPerDay: 260);

const _details = ProductDetails(
  productId: '1',
  brand: '',
  description: '',
  usage: '',
  netContent: '',
  stockQuantity: 12,
  cares: {ProductCare.ingredientList},
  portions: [_small, _large],
);

ProductDetails _withStock(int stockQuantity) {
  return ProductDetails(
    productId: _details.productId,
    brand: _details.brand,
    description: _details.description,
    usage: _details.usage,
    netContent: _details.netContent,
    stockQuantity: stockQuantity,
    cares: _details.cares,
    portions: _details.portions,
  );
}

void main() {
  group('PortionGuide.contains', () {
    test('inclui o peso mínimo e exclui o máximo', () {
      expect(_small.contains(5.0), isTrue);
      expect(_small.contains(9.9), isTrue);
      expect(_small.contains(10.0), isFalse);
      expect(_small.contains(4.9), isFalse);
    });

    test('faixa sem máximo inclui qualquer peso a partir do mínimo', () {
      expect(_large.contains(10.0), isTrue);
      expect(_large.contains(40.0), isTrue);
      expect(_large.contains(9.9), isFalse);
    });
  });

  group('ProductDetails', () {
    test('encontra a faixa de um peso, ou nenhuma', () {
      expect(_details.portionFor(7.0), same(_small));
      expect(_details.portionFor(10.0), same(_large));
      expect(_details.portionFor(4.0), isNull);
    });

    test('estoque baixo fica abaixo do limite e zero está esgotado', () {
      expect(_withStock(0).isOutOfStock, isTrue);
      expect(_withStock(0).isLowStock, isFalse);
      expect(_withStock(4).isOutOfStock, isFalse);
      expect(_withStock(4).isLowStock, isTrue);
      expect(_withStock(5).isLowStock, isFalse);
      expect(_withStock(5).isOutOfStock, isFalse);
    });
  });
}
