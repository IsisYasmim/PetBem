import 'package:flutter/material.dart';

import '../../../../app/common/widgets/section_header.dart';
import '../../../../app/common/widgets/status_message.dart';
import '../../../../app/theme/app_layout.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../products/domain/entities/product.dart';
import '../../../products/domain/repositories/product_repository.dart';
import '../../../products/presentation/pages/product_details_page.dart';
import '../../../products/presentation/widgets/product_card.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../../../profile/domain/profile_match.dart';
import '../../../profile/presentation/pages/profile_form_page.dart';
import '../../../profile/presentation/profile_scope.dart';
import '../greeting.dart';
import '../widgets/best_sellers_loading.dart';
import '../widgets/category_shortcuts.dart';
import '../widgets/home_header.dart';
import '../widgets/orders_shortcut_card.dart';
import '../widgets/profile_prompt_card.dart';
import '../widgets/search_entry.dart';
import '../widgets/secure_payment_note.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.repository});

  final ProductRepository repository;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> _bestSellersFuture;

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

  void _openDetails(Product product) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            ProductDetailsPage(product: product, repository: widget.repository),
      ),
    );
  }

  void _openProfileForm() {
    Navigator.of(context).push(ProfileFormPage.route());
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
    final horizontalPadding = AppLayout.horizontalPadding(
      MediaQuery.sizeOf(context).width,
    );

    final profile = ProfileScope.of(context).profile;

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
                HomeHeader(
                  greeting: greetingFor(DateTime.now()),
                  name: profile.name,
                ),
                const SizedBox(height: AppSpacing.lg),
                SearchEntry(onTap: () => _showComingSoon('A busca')),
                const SizedBox(height: AppSpacing.sm),
                const SecurePaymentNote(),
                if (!profile.isComplete) ...[
                  const SizedBox(height: AppSpacing.lg),
                  ProfilePromptCard(onPressed: _openProfileForm),
                ],
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
                if (profile.isComplete)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xs),
                    child: Text(
                      'Primeiro, os produtos para os seus pets.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.ink.withValues(alpha: 0.8),
                      ),
                    ),
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
            sliver: _buildBestSellers(profile),
          ),
        ],
      ),
    );
  }

  Widget _buildBestSellers(UserProfile profile) {
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
            child: StatusMessage(
              icon: Icons.cloud_off_outlined,
              message: 'Não foi possível carregar os produtos.',
              actionLabel: 'Tentar novamente',
              onAction: _reload,
            ),
          );
        }

        final products = sortByProfile(
          snapshot.data ?? const <Product>[],
          profile,
        );

        if (products.isEmpty) {
          return const SliverToBoxAdapter(
            child: StatusMessage(
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
              matchesProfile: matchesProfile(product, profile),
              onTap: () => _openDetails(product),
            );
          },
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
        );
      },
    );
  }
}
