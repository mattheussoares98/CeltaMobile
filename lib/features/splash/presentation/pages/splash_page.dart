import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/app_router.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: kDebugMode ? 1 : 2), () {
      context.goNamed(AppRoute.auth.name);
    });

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
