import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/constants.dart';
import '../../../../localization/string_hardcoded.dart';
import '../../../../utils/utils.dart';
import '../controllers/auth_state_notifier.dart';
import '../controllers/login_controller.dart';
import 'components/components.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  final enterpriseController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    enterpriseController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(loginControllerProvider, (previous, next) {
      next.showAlertDialogOnError(context);
      next.doOnSuccess(previous, () => ref.invalidate(authStateProvider));
    });

    final loginState = ref.watch(loginControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Autenticação'.hardcoded)),
      body: Padding(
        padding: EdgeInsets.all(Sizes.p24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EnterpriseField(enterpriseController: enterpriseController),
            gapH16,
            EmailField(emailController: emailController),
            gapH16,
            PasswordField(passwordController: passwordController),
            gapH32,
            EnterButton(
              isLoading: loginState.isLoading,
              enterpriseController: enterpriseController,
              emailController: emailController,
              passwordController: passwordController,
            ),
          ],
        ),
      ),
    );
  }
}
