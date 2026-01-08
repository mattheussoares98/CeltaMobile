import 'package:celta_intelligence/features/enterprise_manager/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import 'components/components.dart';

class CreateEnterprisePage extends ConsumerStatefulWidget {
  const CreateEnterprisePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateEnterprisePageState();
}

class _CreateEnterprisePageState extends ConsumerState<CreateEnterprisePage> {
  final enterpriseNameController = TextEditingController();
  final remoteHttpUrlController = TextEditingController();
  final remoteHttpsUrlController = TextEditingController();
  final localHttpUrlController = TextEditingController();
  final localHttpsUrlController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final urlFocusNode = FocusNode();
  final userNameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    enterpriseNameController.dispose();
    remoteHttpUrlController.dispose();
    remoteHttpsUrlController.dispose();
    localHttpUrlController.dispose();
    localHttpsUrlController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    urlFocusNode.dispose();
    userNameFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  Future<void> onSubmit() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    await ref
        .read(createEnterpriseControllerProvider.notifier)
        .createEnterprise(
          remoteHttpUrl: remoteHttpUrlController.text,
          remoteHttpsUrl: remoteHttpsUrlController.text,
          localHttpUrl: localHttpUrlController.text,
          localHttpsUrl: localHttpsUrlController.text,
          enterpriseName: enterpriseNameController.text,
          password: passwordController.text,
          userName: userNameController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      createEnterpriseControllerProvider.select((value) => value.isLoading),
    );
    ref.listen(createEnterpriseControllerProvider, (previous, next) {
      next.showAlertDialogOnError(context);
      next.showSnackbarOnSuccess(
        context,
        previous: previous,
        message: "Empresa cadastrada com sucesso".hardcoded,
      );
      next.doOnSuccess(previous, context.pop);
      ref.invalidate(enterpriseManagerControllerProvider);
    });

    return Scaffold(
      appBar: AppBar(title: Text('Criar empresa'.hardcoded)),
      body: ResponsiveScrollableWidget(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              EnterpriseNameField(
                isLoading: isLoading,
                enterpriseNameController: enterpriseNameController,
                urlFocusNode: urlFocusNode,
              ),
              gapH8,
              UrlField(
                urlController: remoteHttpUrlController,
                urlFocusNode: urlFocusNode,
                isLoading: isLoading,
                userNameFocusNode: userNameFocusNode,
              ),
              gapH8,
              UserNameField(
                userNameController: userNameController,
                userNameFocusNode: userNameFocusNode,
                isLoading: isLoading,
                passwordFocusNode: passwordFocusNode,
              ),
              gapH8,
              PasswordField(
                isLoading: isLoading,
                passwordController: passwordController,
                passwordFocusNode: passwordFocusNode,
                onSubmit: onSubmit,
              ),
              gapH32,
              PrimaryButton(
                text: "Adicionar".hardcoded,
                onPressed: onSubmit,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
