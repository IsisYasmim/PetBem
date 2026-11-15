enum ProductCategory {
  food('Ração'),
  treats('Petiscos'),
  toys('Brinquedos'),
  accessories('Acessórios'),
  hygiene('Higiene');

  const ProductCategory(this.label);

  final String label;
}
