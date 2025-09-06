import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';

class EnterButton extends ConsumerWidget {
  final bool isLoading;
  final TextEditingController enterpriseController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;
  const EnterButton({
    super.key,
    required this.isLoading,
    required this.enterpriseController,
    required this.emailController,
    required this.passwordController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PrimaryButton(
      text: 'Entrar'.hardcoded,
      isLoading: isLoading,
      onPressed: onSubmit,
    );
  }
}
