import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
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
      body: ResponsiveScrollableWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CeltaImage(),
            EnterpriseField(enterpriseController: enterpriseController),
            gapH16,
            EmailField(emailController: emailController),
            gapH16,
            PasswordField(passwordController: passwordController),
            gapH32,
            //TODO validate fields, change focus and submit on password submit
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
