import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petbem/app/theme/app_theme.dart';
import 'package:petbem/features/home/presentation/pages/home_page.dart';
import 'package:petbem/features/home/presentation/widgets/best_sellers_loading.dart';
import 'package:petbem/features/products/domain/entities/pet_type.dart';
import 'package:petbem/features/products/domain/entities/product.dart';
import 'package:petbem/features/products/domain/entities/product_category.dart';
import 'package:petbem/features/products/domain/repositories/product_repository.dart';
import 'package:petbem/features/products/presentation/widgets/product_card.dart';
import 'package:petbem/features/profile/domain/entities/pet.dart';
import 'package:petbem/features/profile/domain/entities/user_profile.dart';
import 'package:petbem/features/profile/presentation/pages/profile_form_page.dart';
import 'package:petbem/features/profile/presentation/profile_controller.dart';
import 'package:petbem/features/profile/presentation/profile_scope.dart';

import '../../support/memory_profile_repository.dart';
import '../../support/stub_product_repository.dart';

Future<void> _pumpHome(
  WidgetTester tester,
  ProductRepository repo, {
  UserProfile profile = UserProfile.empty,
}) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  final controller = ProfileController(
    MemoryProfileRepository(stored: profile),
  );
  addTearDown(controller.dispose);
  await controller.load();

  return tester.pumpWidget(
    ProfileScope(
      controller: controller,
      child: MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(body: HomePage(repository: repo)),
      ),
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
    final repo = StubProductRepository(
      bestSellerResults: [() => response.future],
    );
    await _pumpHome(tester, repo);
    await _scrollToBestSellers(tester);

    expect(find.byType(BestSellersLoading), findsOne);

    response.complete([testProduct]);
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
    final repo = StubProductRepository(bestSellerResults: [() async => []]);
    await _pumpHome(tester, repo);
    await tester.pumpAndSettle();
    await _scrollToBestSellers(tester);

    final message = find.text('Ainda não temos produtos em destaque por aqui.');
    await tester.ensureVisible(message);
    await tester.pumpAndSettle();
    expect(message, findsOne);
  });

  testWidgets('mostra erro e permite tentar novamente', (tester) async {
    final repo = StubProductRepository(
      bestSellerResults: [
        () async => throw Exception('sem conexão'),
        () async => [testProduct],
      ],
    );
    await _pumpHome(tester, repo);
    await tester.pumpAndSettle();
    await _scrollToBestSellers(tester);

    expect(find.text('Não foi possível carregar os produtos.'), findsOne);

    final retry = find.text('Tentar novamente');
    await tester.ensureVisible(retry);
    await tester.pumpAndSettle();
    await tester.tap(retry);
    await tester.pumpAndSettle();

    expect(repo.bestSellerCalls, 2);
    expect(find.text('Ração Teste'), findsOne);
  });

  testWidgets('não busca de novo quando a tela é reconstruída', (tester) async {
    final repo = StubProductRepository(
      bestSellerResults: [
        () async => [testProduct],
      ],
    );
    await _pumpHome(tester, repo);
    await tester.pumpAndSettle();

    // Bombear a mesma árvore de novo força um novo build() da HomePage.
    await _pumpHome(tester, repo);
    await tester.pumpAndSettle();

    expect(repo.bestSellerCalls, 1);
  });

  testWidgets('o convite abre o cadastro da pessoa e dos pets', (tester) async {
    final repo = StubProductRepository(
      bestSellerResults: [
        () async => [testProduct],
      ],
    );
    await _pumpHome(tester, repo);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Completar perfil'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileFormPage), findsOne);
    expect(find.text('Como podemos te chamar?'), findsOne);
    expect(find.text('Seus pets'), findsOne);
    expect(find.text('O que você precisa evitar?'), findsNothing);
  });

  testWidgets('cumpre as promessas de pagamento seguro e de entrega', (
    tester,
  ) async {
    final repo = StubProductRepository(
      bestSellerResults: [
        () async => [testProduct],
      ],
    );
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

  testWidgets('abre o detalhe ao tocar no cartão e volta para a Home', (
    tester,
  ) async {
    final repo = StubProductRepository(
      bestSellerResults: [
        () async => [testProduct],
      ],
      detailsResults: [() async => testProductDetails],
    );
    await _pumpHome(tester, repo);
    await tester.pumpAndSettle();
    await _scrollToBestSellers(tester);

    await tester.ensureVisible(find.text('Ração Teste'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ração Teste'));
    await tester.pumpAndSettle();

    expect(find.text('Cuidados na escolha'), findsOne);
    expect(repo.detailsCalls, 1);

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('Cuidados na escolha'), findsNothing);
    expect(find.text('Ração Teste'), findsOne);
    expect(repo.bestSellerCalls, 1);
  });

  testWidgets('com perfil, os produtos do pet vêm primeiro', (tester) async {
    const cat = Product(
      id: 'cat',
      name: 'Petisco de gato',
      category: ProductCategory.food,
      petTypes: {PetType.cat},
      priceInCents: 1000,
      rating: 4,
      tags: {},
    );
    const dog = Product(
      id: 'dog',
      name: 'Ração de cão',
      category: ProductCategory.food,
      petTypes: {PetType.dog},
      priceInCents: 2000,
      rating: 4.5,
      tags: {},
    );
    final repo = StubProductRepository(
      bestSellerResults: [
        () async => [cat, dog],
      ],
    );
    await _pumpHome(
      tester,
      repo,
      profile: const UserProfile(
        name: 'Ana',
        pets: [Pet(id: '1', name: 'Luna', type: PetType.dog)],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Completar perfil'), findsNothing);
    expect(find.textContaining('Ana'), findsOne);
    expect(find.text('Primeiro, os produtos para os seus pets.'), findsOne);

    await tester.scrollUntilVisible(
      find.text('Petisco de gato'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Para o seu pet'), findsOne);
    expect(
      tester.getTopLeft(find.text('Ração de cão')).dy,
      lessThan(tester.getTopLeft(find.text('Petisco de gato')).dy),
    );
    expect(repo.bestSellerCalls, 1);
  });
}
