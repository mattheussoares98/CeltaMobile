import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../../routing/routing.dart';
import '../../../../utils/utils.dart';
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
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    enterpriseController.dispose();
    userController.dispose();
    passwordController.dispose();
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
        context.goNamed(Routes.home.name);
      });
    });

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
          child: ResponsiveScrollableWidget(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const CeltaImage(),
                  //TODO if the focus is changing correctly on real device after removing the focus nodes
                  EnterpriseField(enterpriseController: enterpriseController),
                  gapH8,
                  UserField(userController: userController),
                  gapH8,
                  PasswordField(
                    passwordController: passwordController,
                    onSubmit: onSubmit,
                  ),
                  gapH32,
                  Consumer(
                    builder: (context, ref, child) {
                      return PrimaryButton(
                        text: 'Entrar'.hardcoded,
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
