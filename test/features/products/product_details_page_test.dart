import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petbem/app/theme/app_theme.dart';
import 'package:petbem/features/products/domain/entities/product_details.dart';
import 'package:petbem/features/products/domain/repositories/product_repository.dart';
import 'package:petbem/features/products/presentation/pages/product_details_page.dart';
import 'package:petbem/features/products/presentation/widgets/details_loading.dart';
import 'package:petbem/features/products/presentation/widgets/photo_carousel.dart';

import '../../support/stub_product_repository.dart';

Future<void> _pumpDetails(
  WidgetTester tester,
  ProductRepository repo, {
  Size size = const Size(360, 800),
  double textScale = 1,
}) {
  tester.view.physicalSize = size * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      home: ProductDetailsPage(product: testProduct, repository: repo),
    ),
  );
}

void main() {
  testWidgets('mostra o resumo na hora e os detalhes depois de carregar', (
    tester,
  ) async {
    final repo = StubProductRepository(
      detailsResults: [() async => testProductDetails],
    );
    await _pumpDetails(tester, repo);

    expect(find.text('Ração Teste'), findsOne);
    expect(find.byType(DetailsLoading), findsOne);

    await tester.pumpAndSettle();

    expect(find.byType(DetailsLoading), findsNothing);
    expect(find.textContaining('Em estoque'), findsOne);
    expect(
      find.text('Lista de ingredientes disponível para consulta'),
      findsOne,
    );
    expect(find.text('90 g por dia'), findsOne);
    expect(find.text('Comprar'), findsOne);
  });

  testWidgets('avisa quando o produto não é encontrado', (tester) async {
    final repo = StubProductRepository(detailsResults: [() async => null]);
    await _pumpDetails(tester, repo);
    await tester.pumpAndSettle();

    expect(
      find.text('As informações deste produto não estão mais disponíveis.'),
      findsOne,
    );
    expect(find.text('Voltar'), findsOne);
  });

  testWidgets('comprar não abre outra página', (tester) async {
    final repo = StubProductRepository(
      detailsResults: [() async => testProductDetails],
    );
    await _pumpDetails(tester, repo);
    await tester.pumpAndSettle();

    final buy = find.text('Comprar');
    await tester.ensureVisible(buy);
    await tester.pumpAndSettle();
    await tester.tap(buy);
    await tester.pumpAndSettle();

    expect(find.byType(ProductDetailsPage), findsOne);
    expect(find.text('Ração Teste'), findsOne);
  });

  testWidgets('mostra erro e permite tentar novamente', (tester) async {
    final repo = StubProductRepository(
      detailsResults: [
        () async => throw Exception('sem conexão'),
        () async => testProductDetails,
      ],
    );
    await _pumpDetails(tester, repo);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tentar novamente'));
    await tester.pumpAndSettle();

    expect(repo.detailsCalls, 2);
    expect(find.text('Uma ração de teste.'), findsOne);
  });

  testWidgets('diz quando o produto está esgotado', (tester) async {
    final outOfStock = ProductDetails(
      productId: testProductDetails.productId,
      brand: testProductDetails.brand,
      description: testProductDetails.description,
      usage: testProductDetails.usage,
      netContent: testProductDetails.netContent,
      stockQuantity: 0,
      cares: testProductDetails.cares,
    );
    final repo = StubProductRepository(
      detailsResults: [() async => outOfStock],
    );
    await _pumpDetails(tester, repo);
    await tester.pumpAndSettle();

    expect(find.text('Esgotado'), findsOne);
    expect(find.text('Porções'), findsNothing);
  });

  testWidgets('mostra as fotos com descrição para o leitor de tela', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    final repo = StubProductRepository(
      detailsResults: [() async => testProductDetails],
    );
    await _pumpDetails(tester, repo);
    await tester.pumpAndSettle();

    expect(find.byType(PhotoCarousel), findsOne);
    expect(find.bySemanticsLabel('Pacote da ração de teste'), findsOne);
    handle.dispose();
  });

  testWidgets('esconde o carrossel quando não há fotos', (tester) async {
    final withoutPhotos = ProductDetails(
      productId: testProductDetails.productId,
      brand: testProductDetails.brand,
      description: testProductDetails.description,
      usage: testProductDetails.usage,
      netContent: testProductDetails.netContent,
      stockQuantity: testProductDetails.stockQuantity,
      cares: testProductDetails.cares,
      portions: testProductDetails.portions,
    );
    final repo = StubProductRepository(
      detailsResults: [() async => withoutPhotos],
    );
    await _pumpDetails(tester, repo);
    await tester.pumpAndSettle();

    expect(find.byType(PhotoCarousel), findsNothing);
    expect(find.text('Uma ração de teste.'), findsOne);
  });

  testWidgets('não transborda com fonte a 200% em tela pequena', (
    tester,
  ) async {
    final repo = StubProductRepository(
      detailsResults: [() async => testProductDetails],
    );
    await _pumpDetails(tester, repo, size: const Size(320, 640), textScale: 2);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('segue as regras de acessibilidade', (tester) async {
    final handle = tester.ensureSemantics();
    final repo = StubProductRepository(
      detailsResults: [() async => testProductDetails],
    );
    await _pumpDetails(tester, repo);
    await tester.pumpAndSettle();

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });
}
