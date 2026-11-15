import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petbem/features/products/domain/entities/pet_type.dart';
import 'package:petbem/features/products/domain/entities/product.dart';
import 'package:petbem/features/products/domain/entities/product_category.dart';
import 'package:petbem/features/products/domain/entities/product_tag.dart';
import 'package:petbem/features/products/presentation/widgets/category_icon_tile.dart';
import 'package:petbem/features/products/presentation/widgets/product_logo.dart';

Product _food(String? imagePath) {
  return Product(
    id: '1',
    name: 'Ração Teste',
    category: ProductCategory.food,
    petTypes: const {PetType.dog},
    priceInCents: 14990,
    rating: 4.8,
    tags: const {ProductTag.natural},
    imagePath: imagePath,
  );
}

Future<void> _pumpLogo(WidgetTester tester, Product product) {
  return tester.pumpWidget(
    MaterialApp(
      home: Center(child: ProductLogo(product: product)),
    ),
  );
}

void main() {
  testWidgets('usa o ícone da categoria quando não há imagem', (tester) async {
    await _pumpLogo(tester, _food(null));

    expect(find.byType(CategoryIconTile), findsOne);
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('mostra a imagem quando há caminho', (tester) async {
    await _pumpLogo(
      tester,
      _food('assets/images/products/racao_natural/image.jpg'),
    );

    expect(find.byType(Image), findsOne);
    expect(find.byType(CategoryIconTile), findsNothing);
  });

  testWidgets('mostra o ícone da categoria quando a imagem não carrega', (
    tester,
  ) async {
    await _pumpLogo(tester, _food('assets/nao_existe.png'));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump();

    expect(find.byIcon(Icons.rice_bowl_outlined), findsOne);
  });
}
