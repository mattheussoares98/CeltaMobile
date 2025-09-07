import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../routing/routing.dart';
import '../../../controllers/controllers.dart';

class EnterButton extends ConsumerWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  const EnterButton({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PrimaryButton(
      text: 'Entrar'.hardcoded,
      isLoading: isLoading,
      onPressed: () async {
        final authResponse = await ref
            .read(authManagerControllerProvider.notifier)
            .login(emailController.text, passwordController.text);

        if (authResponse != null) {
          context.pop();
          context.pushNamed(AppRoute.enterpriseManager.name);
        }
      },
    );
  }
}
