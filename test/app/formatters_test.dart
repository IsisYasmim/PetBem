import 'package:flutter_test/flutter_test.dart';
import 'package:petbem/app/common/formatters.dart';

void main() {
  test('formata decimais com vírgula', () {
    expect(formatDecimal(4.8), '4,8');
    expect(formatDecimal(5), '5,0');
  });

  test('formata preços em reais com dois centavos', () {
    expect(formatPrice(14990), 'R\$ 149,90');
    expect(formatPrice(1290), 'R\$ 12,90');
    expect(formatPrice(5), 'R\$ 0,05');
    expect(formatPrice(0), 'R\$ 0,00');
  });

  test('separa os milhares com ponto', () {
    expect(formatPrice(99999), 'R\$ 999,99');
    expect(formatPrice(100000), 'R\$ 1.000,00');
    expect(formatPrice(129990), 'R\$ 1.299,90');
    expect(formatPrice(100000000), 'R\$ 1.000.000,00');
  });
}
