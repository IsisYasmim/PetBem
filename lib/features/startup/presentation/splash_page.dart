
import 'package:flutter/material.dart';

import '../../onboarding/data/onboarding_storage.dart';
import '../../onboarding/presentation/onboarding_page.dart';
import '../../../app/routes/fade_route.dart';
import '../../../app/shell/app_shell.dart';
import '../../../app/theme/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {

  late final AnimationController _introController;
  late final AnimationController _progressController;

  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Controlador da animação de entrada
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Animação de opacidade (Fade In)
    _fadeAnimation = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.0, 0.65, curve: Curves.easeIn),
    );

    // Animação de escala do conteúdo
    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(
          0.0,
          0.65,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    // Controlador independente da barra de progresso
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _initialize();
  }

  // Inicialização e verificação do primeiro acesso
  Future<void> _initialize() async {

    // 1. Aguarda a animação de entrada terminar
    await _introController.forward();

    if (!mounted) return;

    // 2. Aguarda a barra de progresso completar
    await _progressController.forward();

    if (!mounted) return;

    // 3. Verifica se o usuário já concluiu o onboarding
    final storage = OnboardingStorage();

    final onboardingCompleted = await storage.isCompleted();

    if (!mounted) return;

    // 4. Direciona conforme o estado do onboarding
    if (onboardingCompleted) {
      _goTo(const AppShell());
    } else {
      _goTo(const OnboardingPage());
    }
  }

  // Navegação com transição Fade
  void _goTo(Widget page) {
    Navigator.of(context).pushReplacement(fadeRoute(page));
  }

  @override
  void dispose() {
    _introController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              AppColors.background,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // Logo com sombra suave
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.coral.withValues(alpha: 0.15),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/brand/logo_petbem.png',
                        width: 140,
                        height: 140,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Nome da aplicação
                    const Text(
                      'PetBem',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppColors.coral,
                        letterSpacing: 1.2,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Slogan
                    const Text(
                      'Cuidando do seu pet com amor e carinho',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Barra de progresso independente
                    SizedBox(
                      width: 180,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: AnimatedBuilder(
                          animation: _progressController,
                          builder: (context, child) {
                            return LinearProgressIndicator(
                              value: _progressController.value,
                              backgroundColor:
                                  AppColors.teal.withValues(alpha: 0.2),
                              valueColor:
                                  const AlwaysStoppedAnimation<Color>(
                                AppColors.teal,
                              ),
                              minHeight: 6,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
