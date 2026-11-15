import '../entities/product.dart';
import '../entities/product_details.dart';

/// Contrato de acesso aos produtos.
///
/// A tela conhece só este contrato, nunca a origem dos dados. Hoje a
/// implementação é a FakeProductRepository; quando houver API, entra uma
/// ApiProductRepository e a tela não percebe a troca.
abstract interface class ProductRepository {
  /// Produtos mais vendidos, do mais para o menos vendido.
  Future<List<Product>> fetchBestSellers();

  /// Detalhe de um produto. Null quando a busca funcionou e o produto
  /// não existe mais; uma falha de rede lança exceção, em vez de null.
  Future<ProductDetails?> fetchDetails(String productId);
}
