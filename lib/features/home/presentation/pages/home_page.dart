import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../products/domain/product.dart';
import '../../../products/domain/product_repository.dart';
import '../../../products/presentation/widgets/product_card.dart';
import '../greeting.dart';
import '../widgets/best_sellers_states.dart';
import '../widgets/category_shortcuts.dart';
import '../widgets/home_header.dart';
import '../widgets/orders_shortcut_card.dart';
import '../widgets/profile_prompt_card.dart';
import '../widgets/search_entry.dart';
import '../widgets/secure_payment_note.dart';
import '../widgets/section_header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.repository});

  final ProductRepository repository;

  static const double maxContentWidth = 600;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> _bestSellersFuture;

  // Ainda não existe cadastro de pets. Quando existir, este valor virá
  // de um repositório, e a Home trocará o convite automaticamente.
  final bool _hasRegisteredPet = false;

  @override
  void initState() {
    super.initState();
    _bestSellersFuture = widget.repository.fetchBestSellers();
  }

  void _reload() {
    setState(() {
      _bestSellersFuture = widget.repository.fetchBestSellers();
    });
  }

  Future<void> _refresh() async {
    _reload();
    try {
      await _bestSellersFuture;
    } catch (_) {
      // O erro já é exibido pelo FutureBuilder.
    }
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('$feature estará disponível em breve.')),
      );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = math.max(
      AppSpacing.lg,
      (screenWidth - HomePage.maxContentWidth) / 2,
    );

    return RefreshIndicator(
      onRefresh: _refresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Row(
              children: [
                Image.asset(
                  'assets/brand/logo_petbem.png',
                  height: 32,
                  excludeFromSemantics: true,
                ),
                const SizedBox(width: AppSpacing.sm),
                const Text(
                  'PetBem',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              AppSpacing.sm,
              horizontalPadding,
              0,
            ),
            sliver: SliverList.list(
              children: [
                HomeHeader(greeting: greetingFor(DateTime.now())),
                const SizedBox(height: AppSpacing.lg),
                SearchEntry(onTap: () => _showComingSoon('A busca')),
                const SizedBox(height: AppSpacing.sm),
                const SecurePaymentNote(),
                const SizedBox(height: AppSpacing.lg),
                if (_hasRegisteredPet)
                  ProfilePromptCard.profile(
                    onPressed: () => _showComingSoon('O perfil'),
                  )
                else
                  ProfilePromptCard.pet(
                    onPressed: () => _showComingSoon('O cadastro de pets'),
                  ),
                const SizedBox(height: AppSpacing.md),
                OrdersShortcutCard(
                  onTap: () => _showComingSoon('O acompanhamento de pedidos'),
                ),
                const SizedBox(height: AppSpacing.xl),
                const SectionHeader(title: 'Categorias'),
                const SizedBox(height: AppSpacing.sm),
                CategoryShortcuts(
                  onSelected: (category) =>
                      _showComingSoon('A categoria ${category.label}'),
                ),
                const SizedBox(height: AppSpacing.lg),
                SectionHeader(
                  title: 'Mais vendidos',
                  actionLabel: 'Ver todos',
                  onAction: () => _showComingSoon('A lista completa'),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              0,
              horizontalPadding,
              AppSpacing.xl,
            ),
            sliver: _buildBestSellers(),
          ),
        ],
      ),
    );
  }

  Widget _buildBestSellers() {
    return FutureBuilder<List<Product>>(
      future: _bestSellersFuture,
      builder: (context, snapshot) {
        final isLoading =
            snapshot.connectionState != ConnectionState.done &&
            !snapshot.hasData;

        if (isLoading) {
          return const SliverToBoxAdapter(child: BestSellersLoading());
        }

        if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: BestSellersMessage(
              icon: Icons.cloud_off_outlined,
              message: 'Não foi possível carregar os produtos.',
              actionLabel: 'Tentar novamente',
              onAction: _reload,
            ),
          );
        }

        final products = snapshot.data ?? const <Product>[];

        if (products.isEmpty) {
          return const SliverToBoxAdapter(
            child: BestSellersMessage(
              icon: Icons.shopping_bag_outlined,
              message: 'Ainda não temos produtos em destaque por aqui.',
            ),
          );
        }

        return SliverList.separated(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onTap: () => _showComingSoon('O detalhe do produto'),
            );
          },
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
        );
      },
    );
  }
}
