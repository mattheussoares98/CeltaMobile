import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  UserSessionModel? _userSession;
  bool _sessionLoaded = false;
  final _animationDuration = const Duration(milliseconds: 3500);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await Future.delayed(_animationDuration);

        _initializeApp();
      }
    });
  }

  Future<void> _initializeApp() async {
    _userSession = await ref.read(userSessionProvider.future);
    _sessionLoaded = true;

    if (mounted) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p24),
        child: LogoWidget(
          animate: true,
          animationDuration: const Duration(milliseconds: 3500),
          onAnimationComplete: _navigateToNextScreen,
        ),
      ),
    );
  }
}
