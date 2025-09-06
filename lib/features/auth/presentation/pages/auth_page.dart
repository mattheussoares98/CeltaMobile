import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
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
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  final userFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    enterpriseController.dispose();
    userController.dispose();
    passwordController.dispose();
    userFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  void onSubmit() {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    ref
        .read(loginControllerProvider.notifier)
        .login(
          enterpriseName: enterpriseController.text,
          userName: userController.text,
          password: passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(loginControllerProvider, (previous, next) {
      next.showAlertDialogOnError(context);
      next.doOnSuccess(previous, () => ref.invalidate(authStateProvider));
    });

    final loginState = ref.watch(loginControllerProvider);

    return Scaffold(
      body: ResponsiveScrollableWidget(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CeltaImage(),
              EnterpriseField(
                enterpriseController: enterpriseController,
                userFocusNode: userFocusNode,
              ),
              gapH8,
              UserField(
                userController: userController,
                userFocusNode: userFocusNode,
                passwordFocusNode: passwordFocusNode,
              ),
              gapH8,
              PasswordField(
                passwordController: passwordController,
                passwordFocusNode: passwordFocusNode,
                onSubmit: onSubmit,
              ),
              gapH32,
              EnterButton(
                isLoading: loginState.isLoading,
                enterpriseController: enterpriseController,
                emailController: userController,
                passwordController: passwordController,
                onSubmit: onSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
