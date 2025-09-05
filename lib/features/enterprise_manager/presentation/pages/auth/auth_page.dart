import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../localization/string_hardcoded.dart';
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
      body: ResponsiveScrollableWidget(
        centralize: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmailField(
              emailController: emailController,
              isLoading: authManagerState.isLoading,
            ),
            gapH16,
            PasswordField(
              passwordController: passwordController,
              isLoading: authManagerState.isLoading,
            ),
            gapH32,
            //TODO validate fields, change focus and submit on password submit
            EnterButton(
              emailController: emailController,
              passwordController: passwordController,
              isLoading: authManagerState.isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
