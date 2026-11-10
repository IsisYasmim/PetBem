import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petbem/app/theme/app_theme.dart';
import 'package:petbem/features/home/presentation/pages/home_page.dart';
import 'package:petbem/features/home/presentation/widgets/best_sellers_states.dart';
import 'package:petbem/features/products/domain/pet_type.dart';
import 'package:petbem/features/products/domain/product.dart';
import 'package:petbem/features/products/domain/product_category.dart';
import 'package:petbem/features/products/domain/product_repository.dart';
import 'package:petbem/features/products/domain/product_tag.dart';
import 'package:petbem/features/products/presentation/widgets/product_card.dart';

class _StubRepository implements ProductRepository {
  _StubRepository(this._results);

  final List<Future<List<Product>> Function()> _results;
  int calls = 0;

  @override
  Future<List<Product>> fetchBestSellers() => _results[calls++]();
}

const _racao = Product(
  id: '1',
  name: 'Ração Teste',
  category: ProductCategory.food,
  petTypes: {PetType.dog},
  priceInCents: 14990,
  rating: 4.8,
  tags: {ProductTag.natural},
);

Future<void> _pumpHome(WidgetTester tester, ProductRepository repo) {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: HomePage(repository: repo)),
    ),
  );
}

/// Rola a Home até a seção "Mais vendidos", como o usuário faria. A lista
/// fica no fim da página e, fora da tela, nem chega a ser construída.
Future<void> _scrollToBestSellers(WidgetTester tester) async {
  await tester.scrollUntilVisible(
    find.text('Mais vendidos'),
    200,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

/// Procura o texto só dentro dos cartões de produto. "Ração", por exemplo,
/// também aparece nos atalhos de categoria.
Finder _inCard(String text) =>
    find.descendant(of: find.byType(ProductCard), matching: find.text(text));

void main() {
  testWidgets('mostra carregamento e depois os produtos', (tester) async {
    // O Completer segura a resposta até o teste decidir entregá-la.
    final response = Completer<List<Product>>();
    final repo = _StubRepository([() => response.future]);
    await _pumpHome(tester, repo);
    await _scrollToBestSellers(tester);

    expect(find.byType(BestSellersLoading), findsOne);

    response.complete([_racao]);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Ração Teste'));
    await tester.pumpAndSettle();

    expect(_inCard('Ração Teste'), findsOne);
    expect(_inCard('Ração'), findsOne);
    expect(_inCard('R\$ 149,90'), findsOne);
    expect(_inCard('Cães'), findsOne);
    expect(_inCard('Natural'), findsOne);
    expect(_inCard('4,8'), findsOne);
  });

  testWidgets('mostra mensagem quando não há produtos', (tester) async {
    final repo = _StubRepository([() async => []]);
    await _pumpHome(tester, repo);
    await tester.pumpAndSettle();
    await _scrollToBestSellers(tester);

    final message = find.text('Ainda não temos produtos em destaque por aqui.');
    await tester.ensureVisible(message);
    await tester.pumpAndSettle();
    expect(message, findsOne);
  });

  testWidgets('mostra erro e permite tentar novamente', (tester) async {
    final repo = _StubRepository([
      () async => throw Exception('sem conexão'),
      () async => [_racao],
    ]);
    await _pumpHome(tester, repo);
    await tester.pumpAndSettle();
    await _scrollToBestSellers(tester);

    expect(find.text('Não foi possível carregar os produtos.'), findsOne);

    final retry = find.text('Tentar novamente');
    await tester.ensureVisible(retry);
    await tester.pumpAndSettle();
    await tester.tap(retry);
    await tester.pumpAndSettle();

    expect(repo.calls, 2);
    expect(find.text('Ração Teste'), findsOne);
  });

  testWidgets('não busca de novo quando a tela é reconstruída', (tester) async {
    final repo = _StubRepository([
      () async => [_racao],
    ]);
    await _pumpHome(tester, repo);
    await tester.pumpAndSettle();

    // Bombear a mesma árvore de novo força um novo build() da HomePage.
    await _pumpHome(tester, repo);
    await tester.pumpAndSettle();

    expect(repo.calls, 1);
  });

  testWidgets('avisa que o cadastro de pets ainda não está disponível', (
    tester,
  ) async {
    final repo = _StubRepository([
      () async => [_racao],
    ]);
    await _pumpHome(tester, repo);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cadastrar pet'));
    await tester.pump();

    expect(
      find.text('O cadastro de pets estará disponível em breve.'),
      findsOne,
    );
  });

  testWidgets('cumpre as promessas de pagamento seguro e de entrega', (
    tester,
  ) async {
    final repo = _StubRepository([
      () async => [_racao],
    ]);
    await _pumpHome(tester, repo);
    await tester.pumpAndSettle();

    expect(find.text('Pagamento seguro e checkout simplificado'), findsOne);

    final orders = find.text('Meus pedidos');
    await tester.ensureVisible(orders);
    await tester.pumpAndSettle();
    await tester.tap(orders);
    await tester.pump();

    expect(
      find.text('O acompanhamento de pedidos estará disponível em breve.'),
      findsOne,
    );
  });
}
