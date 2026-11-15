/// Faixa de peso do pet e a quantidade diária correspondente.
///
/// O intervalo é semiaberto: inclui [minWeightKg] e exclui [maxWeightKg].
/// Assim, 5 kg pertence à faixa que começa em 5, e não à que termina em 5.
/// [maxWeightKg] nulo significa "deste peso para cima".
class PortionGuide {
  const PortionGuide({
    required this.minWeightKg,
    required this.gramsPerDay,
    this.maxWeightKg,
  });

  final double minWeightKg;
  final double? maxWeightKg;
  final int gramsPerDay;

  bool contains(double weightKg) {
    if (weightKg < minWeightKg) {
      return false;
    }
    final maxWeightKg = this.maxWeightKg;
    if (maxWeightKg == null) {
      return true;
    }
    return weightKg < maxWeightKg;
  }
}
