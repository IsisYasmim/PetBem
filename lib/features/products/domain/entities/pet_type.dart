enum PetType {
  dog('Cães'),
  cat('Gatos'),
  bird('Pássaros'),
  fish('Peixes'),
  hamster('Hamsters');

  const PetType(this.label);

  final String label;
}
