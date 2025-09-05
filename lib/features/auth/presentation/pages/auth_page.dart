import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/presentation/theme/app_decorations.dart';
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
    final theme = Theme.of(context);

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
              decoration: AppDecorations.input(
                context: context,
                labelText: 'Empresa'.hardcoded,
                prefixIcon: Icon(
                  theme.platform == TargetPlatform.iOS
                      ? CupertinoIcons.building_2_fill
                      : Icons.business,
                ),
              ),
            ),
            gapH16,
            TextField(
              controller: emailController,
              decoration: AppDecorations.input(
                context: context,
                labelText: 'Email'.hardcoded,
                prefixIcon: Icon(
                  theme.platform == TargetPlatform.iOS
                      ? CupertinoIcons.mail_solid
                      : Icons.email_outlined,
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            gapH16,
            TextField(
              controller: passwordController,
              decoration: AppDecorations.input(
                context: context,
                labelText: 'Senha'.hardcoded,
                prefixIcon: Icon(
                  theme.platform == TargetPlatform.iOS
                      ? CupertinoIcons.lock_fill
                      : Icons.lock_outline,
                ),
              ),
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
                      userName: emailController.text,
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
