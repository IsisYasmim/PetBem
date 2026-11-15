import 'package:flutter/material.dart';

import '../../../../app/common/widgets/status_message.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_layout.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_details.dart';
import '../../domain/repositories/product_repository.dart';
import '../product_hero_tag.dart';
import '../widgets/contact_actions.dart';
import '../widgets/details_loading.dart';
import '../widgets/details_section.dart';
import '../widgets/photo_carousel.dart';
import '../widgets/portion_table.dart';
import '../widgets/product_care_list.dart';
import '../widgets/product_logo.dart';
import '../widgets/product_summary.dart';
import '../widgets/stock_status.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({
    super.key,
    required this.product,
    required this.repository,
  });

  final Product product;
  final ProductRepository repository;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late Future<ProductDetails?> _detailsFuture;

  @override
  void initState() {
    super.initState();
    _detailsFuture = widget.repository.fetchDetails(widget.product.id);
  }

  void _reload() {
    setState(() {
      _detailsFuture = widget.repository.fetchDetails(widget.product.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = AppLayout.horizontalPadding(
      MediaQuery.sizeOf(context).width,
    );

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: horizontalPadding),
            child: Hero(
              tag: productHeroTag(widget.product.id),
              child: ProductLogo(product: widget.product, size: 40),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          AppSpacing.sm,
          horizontalPadding,
          AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProductSummary(product: widget.product),
            const SizedBox(height: AppSpacing.lg),
            _buildDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetails() {
    return FutureBuilder<ProductDetails?>(
      future: _detailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const DetailsLoading();
        }

        if (snapshot.hasError) {
          return StatusMessage(
            icon: Icons.cloud_off_outlined,
            message: 'Não foi possível carregar as informações deste produto.',
            actionLabel: 'Tentar novamente',
            onAction: _reload,
          );
        }

        final details = snapshot.data;

        if (details == null) {
          return StatusMessage(
            icon: Icons.inventory_2_outlined,
            message: 'As informações deste produto não estão mais disponíveis.',
            actionLabel: 'Voltar',
            onAction: () => Navigator.of(context).pop(),
          );
        }

        return _buildContent(details);
      },
    );
  }

  Widget _buildContent(ProductDetails details) {
    final textStyle = Theme.of(context).textTheme.bodyMedium
        ?.copyWith(color: AppColors.ink, height: 1.4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (details.photos.isNotEmpty) ...[
          PhotoCarousel(photos: details.photos),
          const SizedBox(height: AppSpacing.lg),
        ],
        StockStatus(details: details),
        const SizedBox(height: AppSpacing.md),
        const ContactActions(),
        const SizedBox(height: AppSpacing.xl),
        DetailsSection(
          title: 'Cuidados na escolha',
          child: ProductCareList(cares: details.cares),
        ),
        const SizedBox(height: AppSpacing.lg),
        DetailsSection(
          title: 'Modo de uso',
          child: Text(details.usage, style: textStyle),
        ),
        if (details.portions.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          DetailsSection(
            title: 'Porções',
            child: PortionTable(portions: details.portions),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        DetailsSection(
          title: 'Sobre',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(details.description, style: textStyle),
              const SizedBox(height: AppSpacing.sm),
              _InfoLine(icon: Icons.scale_outlined, text: details.netContent),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        DetailsSection(
          title: 'Marca',
          child: _InfoLine(
            icon: Icons.storefront_outlined,
            text: details.brand,
          ),
        ),
      ],
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.ink),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: AppColors.ink),
          ),
        ),
      ],
    );
  }
}
