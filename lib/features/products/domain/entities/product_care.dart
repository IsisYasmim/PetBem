/// Cuidado que o fabricante declara sobre o produto.
///
/// Os rótulos descrevem fatos (o que a embalagem informa), e não garantias
/// que o app não tem como verificar.
enum ProductCare {
  ingredientList('Lista de ingredientes disponível para consulta'),
  veterinaryGuidance('Fórmula desenvolvida com orientação veterinária'),
  ageOnPackage('Faixa etária indicada na embalagem'),
  traceableBatch('Lote rastreável pelo código da embalagem');

  const ProductCare(this.label);

  final String label;
}
