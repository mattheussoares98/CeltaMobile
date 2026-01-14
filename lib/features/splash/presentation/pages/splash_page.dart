import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../../routing/routing.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;

  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();

    _pulseAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final userSession = await ref.read(userSessionProvider.future);

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    if (userSession?.user.AccessKey == null ||
        userSession?.user.CrossIdentity_Usuario == null) {
      context.goNamed(Routes.auth.name);
    } else {
      context.goNamed(Routes.home.name);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([_pulseController]),
          builder: (context, child) {
            final double currentScale = _pulseAnimation.value;

            return Transform.scale(
              scale: currentScale,
              child: Hero(
                tag: "logo",
                child: Image.asset(
                  "lib/core/assets/images/logoCeltaTransparente.png",
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
