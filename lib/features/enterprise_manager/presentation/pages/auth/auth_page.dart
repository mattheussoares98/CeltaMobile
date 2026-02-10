import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../../../../routing/routing.dart';
import '../../../../../utils/utils.dart';
import '../../../../../constants/constants.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _EnterpriseManagerAuthPageState();
}

class _EnterpriseManagerAuthPageState extends ConsumerState<AuthPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> onSubmit() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    final authResponse = await ref
        .read(authManagerControllerProvider.notifier)
        .login(emailController.text, passwordController.text);

    if (authResponse != null) {
      context.pop();
      context.pushNamed(Routes.enterpriseManager.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(authManagerControllerProvider, (
      previous,
      next,
    ) {
      next.showAlertDialogOnError(context);
    });
    final authManagerState = ref.watch(authManagerControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Login'.hardcoded)),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: ResponsiveScrollableWidget(
          centralize: true,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                EmailField(
                  emailController: emailController,
                  passwordFocusNode: passwordFocusNode,
                  isLoading: authManagerState.isLoading,
                ),
                gapH16,
                PasswordField(
                  passwordFocusNode: passwordFocusNode,
                  passwordController: passwordController,
                  isLoading: authManagerState.isLoading,
                  onSubmit: onSubmit,
                ),
                gapH32,
                EnterButton(
                  emailController: emailController,
                  passwordController: passwordController,
                  isLoading: authManagerState.isLoading,
                  onSubmit: onSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
