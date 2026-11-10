
import 'package:flutter/material.dart';

import '../data/onboarding_storage.dart';
import '../domain/onboarding_item.dart';
import '../../../app/routes/fade_route.dart';
import '../../../app/shell/app_shell.dart';
import '../../../app/theme/app_colors.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  static const List<OnboardingItem> items = [
    OnboardingItem(
      title: 'Descubra produtos',
      description:
          'Encontre rações, brinquedos e acessórios para seu pet.',
      imagePath: 'assets/onboarding/products.jpg',
    ),
    OnboardingItem(
      title: 'Pagamento Seguro',
      description:
          'Check-out simplificado & pagamento seguro.',
      imagePath: 'assets/onboarding/payment.jpg',
    ),
    OnboardingItem(
      title: 'Acompanhe Entrega',
      description:
          'Acompanhe pedidos em tempo real.',
      imagePath: 'assets/onboarding/delivery.jpg',
    ),
  ];

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {

  late final AnimationController _introController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  final PageController _pageController = PageController();

  int _currentPage = 0;
  bool _isFinishing = false;

  @override
  void initState() {
    super.initState();

    _introController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _introController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: Curves.easeOutCubic,
      ),
    );

    _introController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _introController.dispose();
    super.dispose();
  }

  Future<void> _nextPage() async {
    if (_isFinishing) return;

    if (_currentPage < OnboardingPage.items.length - 1) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      await _finishOnboarding();
    }
  }

  Future<void> _finishOnboarding() async {
    if (_isFinishing) return;

    setState(() => _isFinishing = true);

    try {
      final storage = OnboardingStorage();
      await storage.markAsCompleted();

      if (!mounted) return;

      Navigator.of(context).pushReplacement(fadeRoute(const AppShell()));
    } catch (e) {
      if (!mounted) return;

      setState(() => _isFinishing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível concluir a apresentação. Tente novamente.',
          ),
        ),
      );
    }
  }

  Widget _buildTopBar() {
    final isLastPage =
        _currentPage == OnboardingPage.items.length - 1;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 8,
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: AnimatedOpacity(
            opacity: isLastPage ? 0 : 1,
            duration: const Duration(milliseconds: 200),
            child: TextButton(
              onPressed: isLastPage || _isFinishing
                  ? null
                  : _finishOnboarding,
              child: const Text(
                'Pular',
                style: TextStyle(
                  color: AppColors.coral,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        OnboardingPage.items.length,
        (index) {
          final isActive = index == _currentPage;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isActive ? 26 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.coral
                  : AppColors.teal.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage =
        _currentPage == OnboardingPage.items.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          FadeTransition(
            opacity: _fadeAnimation,
            child: _buildTopBar(),
          ),

          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: OnboardingPage.items.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return _OnboardingContent(
                      item: OnboardingPage.items[index],
                    );
                  },
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 28),
            child: _buildPageIndicator(),
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: SizedBox(
            height: 56,
            child: FilledButton(
              onPressed: _isFinishing ? null : _nextPage,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.coral,
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    AppColors.coral.withValues(alpha: 0.6),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _isFinishing
                    ? const SizedBox(
                        key: ValueKey('loading'),
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        isLastPage ? 'Começar' : 'Próximo',
                        key: ValueKey(_currentPage),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingContent extends StatelessWidget {
  const _OnboardingContent({
    required this.item,
  });

  final OnboardingItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          const Spacer(flex: 1),

          // Imagem ilustrativa de cada etapa.
          Flexible(
            flex: 7,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4F1),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.coral.withValues(alpha: 0.10),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                item.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.pets_rounded,
                      size: 90,
                      color: AppColors.teal,
                    ),
                  );
                },
              ),
            ),
          ),

          const Spacer(flex: 1),

          // Título.
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall?.copyWith(
              color: AppColors.coral,
              fontWeight: FontWeight.bold,
              fontSize: 27,
            ),
          ),

          const SizedBox(height: 16),

          // Detalhe decorativo.
          Container(
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.teal,
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          const SizedBox(height: 18),

          // Descrição.
          Text(
            item.description,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(
              color: Colors.black54,
              height: 1.5,
              fontSize: 16,
            ),
          ),

          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
