import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../controllers/controllers.dart';

class EnterButton extends ConsumerWidget {
  final bool isLoading;
  final TextEditingController enterpriseController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const EnterButton({
    super.key,
    required this.isLoading,
    required this.enterpriseController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PrimaryButton(
      text: 'Entrar'.hardcoded,
      isLoading: isLoading,
      onPressed: () {
        ref
            .read(loginControllerProvider.notifier)
            .login(
              enterpriseName: enterpriseController.text,
              userName: emailController.text,
              password: passwordController.text,
            );
      },
    );
  }
}
