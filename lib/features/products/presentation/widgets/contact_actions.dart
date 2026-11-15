import 'package:flutter/material.dart';

/// A compra ainda não abre outra tela. O toque fica nesta página.
class ContactActions extends StatelessWidget {
  const ContactActions({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.shopping_bag_outlined),
      label: const Text('Comprar'),
    );
  }
}
