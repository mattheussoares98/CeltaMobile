import 'package:celta_intelligence/features/enterprise_manager/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final urlController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final urlFocusNode = FocusNode();
  final userNameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    enterpriseNameController.dispose();
    urlController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    urlFocusNode.dispose();
    userNameFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  Future<void> onSubmit() async {
    await ref
        .read(createEnterpriseControllerProvider.notifier)
        .createEnterprise(
          baseUrl: urlController.text,
          enterpriseName: enterpriseNameController.text,
          password: passwordController.text,
          userName: userNameController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final createEnterpriseAsync = ref.watch(createEnterpriseControllerProvider);
    ref.listen(createEnterpriseControllerProvider, (previous, next) {
      next.showAlertDialogOnError(context);
      next.showSnackbarOnSuccess(
        context,
        previous: previous,
        message: "Empresa cadastrada com sucesso".hardcoded,
      );
      // next.doOnSuccess(previous, context.pop); //TODO return this
      ref.invalidate(enterpriseManagerControllerProvider);
    });

    return Scaffold(
      appBar: AppBar(title: Text('Criar empresa'.hardcoded)),
      body: ResponsiveScrollableWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            EnterpriseNameField(
              isLoading: createEnterpriseAsync.isLoading,
              enterpriseNameController: enterpriseNameController,
              urlFocusNode: urlFocusNode,
            ),
            gapH8,
            UrlField(
              urlController: urlController,
              urlFocusNode: urlFocusNode,
              isLoading: createEnterpriseAsync.isLoading,
              userNameFocusNode: userNameFocusNode,
            ),
            gapH8,
            UserNameField(
              userNameController: userNameController,
              userNameFocusNode: userNameFocusNode,
              isLoading: createEnterpriseAsync.isLoading,
              passwordFocusNode: passwordFocusNode,
            ),
            gapH8,
            PasswordField(
              isLoading: createEnterpriseAsync.isLoading,
              passwordController: passwordController,
              passwordFocusNode: passwordFocusNode,
              onSubmit: onSubmit,
            ),
            gapH32,
            PrimaryButton(
              text: "Adicionar".hardcoded,
              onPressed: onSubmit,
              isLoading: createEnterpriseAsync.isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
