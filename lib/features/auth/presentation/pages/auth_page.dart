import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../localization/string_hardcoded.dart';
import '../../../../utils/utils.dart';
import '../controllers/auth_state_notifier.dart';
import '../controllers/login_controller.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  final enterpriseController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    enterpriseController.dispose();
    userNameController.dispose();
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
            TextField(
              controller: enterpriseController,
              decoration: InputDecoration(labelText: 'Empresa'.hardcoded),
            ),
            gapH16,
            TextField(
              controller: userNameController,
              decoration: InputDecoration(labelText: 'Email'.hardcoded),
              keyboardType: TextInputType.emailAddress,
            ),
            gapH16,
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Senha'.hardcoded),
              obscureText: true,
            ),
            gapH32,
            PrimaryButton(
              text: 'Entrar'.hardcoded,
              isLoading: loginState.isLoading,
              onPressed: () {
                ref
                    .read(loginControllerProvider.notifier)
                    .login(
                      enterpriseName: enterpriseController.text,
                      userName: userNameController.text,
                      password: passwordController.text,
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
