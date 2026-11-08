
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const Color primaryColor = Color(0xFFFF705D);
  static const Color secondaryColor = Color(0xFF40C4C8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text(
          'Meu Perfil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),

            // Avatar do usuário.
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: secondaryColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_rounded,
                size: 55,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Olá, usuário!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Bem-vindo ao PetBem!',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 30),

            // Opções do perfil.
            _ProfileOption(
              icon: Icons.person_outline,
              title: 'Dados pessoais',
              subtitle: 'Gerencie suas informações',
              onTap: () {},
            ),

            _ProfileOption(
              icon: Icons.shopping_bag_outlined,
              title: 'Meus pedidos',
              subtitle: 'Consulte seu histórico de compras',
              onTap: () {},
            ),

            _ProfileOption(
              icon: Icons.pets_outlined,
              title: 'Meus pets',
              subtitle: 'Gerencie os dados dos seus animais',
              onTap: () {},
            ),

            _ProfileOption(
              icon: Icons.location_on_outlined,
              title: 'Endereços',
              subtitle: 'Gerencie seus endereços de entrega',
              onTap: () {},
            ),

            _ProfileOption(
              icon: Icons.payment_outlined,
              title: 'Formas de pagamento',
              subtitle: 'Gerencie seus pagamentos',
              onTap: () {},
            ),

            _ProfileOption(
              icon: Icons.settings_outlined,
              title: 'Configurações',
              subtitle: 'Preferências do aplicativo',
              onTap: () {},
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  static const Color primaryColor = Color(0xFFFF705D);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 6,
        ),
        leading: Icon(
          icon,
          color: primaryColor,
          size: 26,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Colors.black38,
        ),
        onTap: onTap,
      ),
    );
  }
}
