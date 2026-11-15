import 'package:flutter/material.dart';

/// Cores da marca PetBem.
///
/// Regras de contraste (WCAG; mínimo 4,5:1 para texto comum):
/// - Texto principal: [ink] (15,2:1 sobre [background]).
/// - Texto secundário: [ink] com 70% de opacidade (5,8:1 sobre [background]).
///   Com 60% cai para 4,2:1 e reprova.
/// - [coral] e [teal] nunca são cor de texto (2,6:1 e 2,0:1 sobre
///   [background]); são fundo ou decoração.
/// - Sobre [coral] ou [teal], texto [ink] (5,9:1 e 7,6:1).
/// - Sobre [ink], texto branco (16,1:1).
abstract final class AppColors {
  static const Color coral = Color(0xFFFF705D);
  static const Color teal = Color(0xFF40C4C8);
  static const Color ink = Color(0xFF212121);
  static const Color background = Color(0xFFFFF6F5);
}
