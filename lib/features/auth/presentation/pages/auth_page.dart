import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/auth/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/auth/presentation/pages/components/components.dart';
import 'package:celta_inventario/features/home/presentation/controllers/controllers.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final userSession = await ref
            .read(userSessionProvider.notifier)
            .build();

        userController.text = userSession?.user.name ?? '';
        enterpriseController.text = userSession?.user.enterpriseName ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(loginControllerProvider, (previous, next) {
      next.showAlertDialogOnError(context);
      next.doOnSuccess(previous, () {
        // Invalidate the keepAlive provider so it re-runs with the new
        // session, then pre-warm it before navigating to avoid a
        // markNeedsBuild crash when HomePage first builds.
        ref.invalidate(homeInitializationControllerProvider);
        ref.read(homeInitializationControllerProvider);
        context.goNamed(Routes.home.name);
      });
    });

    return BaseScaffold(
      isScrollable: false,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: ResponsiveScrollableWidget(
          child: Form(
            key: formKey,
            child: AutofillGroup(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const CeltaImage(),
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
                  Consumer(
                    builder: (context, ref, child) {
                      return PrimaryButton(
                        text: context.l10n.signIn,
                        onPressed: onSubmit,
                        isLoading: ref.watch(loginControllerProvider).isLoading,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
