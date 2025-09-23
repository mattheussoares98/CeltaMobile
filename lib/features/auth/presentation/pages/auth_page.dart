import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/providers/user_session/user_session.dart';
import '../../../../routing/routing.dart';
import '../../../../utils/utils.dart';
import '../controllers/auth_state_controller.dart';
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
  bool showPassword = false;

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
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final user = await ref
            .read(authStateControllerProvider.notifier)
            .build();

        userController.text = user?.name ?? '';
        enterpriseController.text = user?.enterpriseName ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(loginControllerProvider, (previous, next) {
      next.showAlertDialogOnError(context);
      next.doOnSuccess(previous, () {
        ref.invalidate(authStateControllerProvider);
        ref.invalidate(userSessionProvider);
        context.goNamed(AppRoute.home.name);
      });
    });

    final loginAsync = ref.watch(loginControllerProvider);

    return Scaffold(
      body: ResponsiveScrollableWidget(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CeltaImage(),
              EnterpriseField(
                isLoading: loginAsync.isLoading,
                enterpriseController: enterpriseController,
                userFocusNode: userFocusNode,
              ),
              gapH8,
              UserField(
                isLoading: loginAsync.isLoading,
                userController: userController,
                userFocusNode: userFocusNode,
                passwordFocusNode: passwordFocusNode,
              ),
              gapH8,
              PasswordField(
                isLoading: loginAsync.isLoading,
                passwordController: passwordController,
                passwordFocusNode: passwordFocusNode,
                onSubmit: loginAsync.isLoading ? null : onSubmit,
                showPassword: showPassword,
                changeShowPassword: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
              ),
              gapH32,
              PrimaryButton(
                text: 'Entrar'.hardcoded,
                isLoading: loginAsync.isLoading,
                onPressed: loginAsync.isLoading ? null : onSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
