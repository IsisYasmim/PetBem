import 'product.dart';

/// Contrato de acesso aos produtos.
///
/// A tela conhece só este contrato, nunca a origem dos dados. Hoje a
/// implementação é a FakeProductRepository; quando houver API, entra uma
/// ApiProductRepository e a tela não percebe a troca.
abstract interface class ProductRepository {
  /// Produtos mais vendidos, do mais para o menos vendido.
  Future<List<Product>> fetchBestSellers();
}
