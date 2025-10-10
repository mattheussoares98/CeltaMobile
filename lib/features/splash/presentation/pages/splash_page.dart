import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../../routing/routing.dart';

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
        final userSession = await ref.read(userSessionProvider.future);
        Future.delayed(const Duration(seconds: kDebugMode ? 1 : 2), () {
          if (userSession?.user.AccessKey == null ||
              userSession?.user.CrossIdentity_Usuario == null) {
            context.goNamed(Routes.auth.name);
          } else {
            context.goNamed(Routes.home.name);
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
