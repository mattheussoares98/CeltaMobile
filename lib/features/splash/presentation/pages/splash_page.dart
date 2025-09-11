import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/app_router.dart';
import '../../../auth/presentation/controllers/controllers.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localUser = ref.read(authStateControllerProvider).valueOrNull;
    Future.delayed(const Duration(seconds: kDebugMode ? 1 : 2), () {
      if (localUser == null) {
        context.goNamed(AppRoute.auth.name);
      } else {
        context.goNamed(AppRoute.home.name);
      }
    });

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
