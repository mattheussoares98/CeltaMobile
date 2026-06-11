import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'components/components.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  UserSessionModel? _userSession;
  bool _sessionLoaded = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToNextScreen();
      }
    });

    _animationController.forward();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    _userSession = await ref.read(userSessionProvider.future);
    _sessionLoaded = true;

    if (_animationController.isCompleted && mounted) {
      _navigateToNextScreen();
    }
  }

  void _navigateToNextScreen() {
    if (!_sessionLoaded || !mounted) return;

    if (_userSession?.user.AccessKey == null ||
        _userSession?.user.CrossIdentity_Usuario == null) {
      context.goNamed(Routes.auth.name);
    } else {
      context.goNamed(Routes.home.name);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 150.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p24),
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LogoImage(
                  animationController: _animationController,
                  textStyle: textStyle,
                ),
                gapW16,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CeltawareLetters(
                      textStyle: textStyle,
                      animationController: _animationController,
                    ),
                    TechnologyAndSolutions(
                      animationController: _animationController,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
