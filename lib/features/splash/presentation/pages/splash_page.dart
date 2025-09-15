import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/app_router.dart';
import '../../../auth/presentation/controllers/controllers.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final localUser = await ref.read(authStateControllerProvider.future);
        Future.delayed(const Duration(seconds: kDebugMode ? 1 : 2), () {
          if (localUser?.AccessKey == null ||
              localUser?.CrossIdentity_Usuario == null) {
            context.goNamed(AppRoute.auth.name);
          } else {
            context.goNamed(AppRoute.home.name);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
