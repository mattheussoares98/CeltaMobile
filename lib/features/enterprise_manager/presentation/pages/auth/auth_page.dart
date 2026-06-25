import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/enterprise_manager/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/enterprise_manager/presentation/pages/auth/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

    if (authResponse != null && mounted) {
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

    return BaseScaffold(
      isScrollable: false,
      usePadding: true,
      appBar: DefaultAppBar(
        title: 'Login'.hardcoded,
        showSelectedEnterprise: false,
      ),
      body: ResponsiveScrollableWidget(
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
    );
  }
}
