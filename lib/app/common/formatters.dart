/// Número com vírgula decimal: 4.8 → "4,8".
String formatDecimal(double value, {int digits = 1}) {
  return value.toStringAsFixed(digits).replaceAll('.', ',');
}

/// Preço em centavos para reais: 14990 → "R$ 149,90"; 129990 → "R$ 1.299,90".
///
/// Entre "R$" e o número vai um espaço não separável ( ), para o
/// símbolo nunca ficar sozinho no fim de uma linha.
String formatPrice(int cents) {
  final reais = (cents ~/ 100).toString();
  final centavos = (cents % 100).toString().padLeft(2, '0');

  final grouped = StringBuffer();
  for (var i = 0; i < reais.length; i++) {
    if (i > 0 && (reais.length - i) % 3 == 0) {
      grouped.write('.');
    }
    grouped.write(reais[i]);
  }

  return 'R\$ $grouped,$centavos';
}
