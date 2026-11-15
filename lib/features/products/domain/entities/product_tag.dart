enum ProductTag {
  natural('Natural'),
  noArtificialColors('Sem corantes'),
  hypoallergenic('Hipoalergênico'),
  nonToxic('Atóxico'),
  crueltyFree('Livre de crueldade'),
  sustainable('Sustentável');

  const ProductTag(this.label);

  final String label;
}
