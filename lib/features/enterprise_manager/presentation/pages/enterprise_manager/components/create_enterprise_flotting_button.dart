import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/presentation/theme/theme.dart';
import '../../../controllers/controllers.dart';
import 'components.dart';

class CreateEnterpriseFlottingButton extends ConsumerWidget {
  final TextEditingController enterpriseNameController;
  final TextEditingController urlController;
  final TextEditingController userNameController;
  final TextEditingController passwordController;
  final FocusNode urlFocusNode;
  final FocusNode userNameFocusNode;
  final FocusNode passwordFocusNode;
  final VoidCallback onSubmit;
  const CreateEnterpriseFlottingButton({
    super.key,
    required this.enterpriseNameController,
    required this.urlController,
    required this.userNameController,
    required this.passwordController,
    required this.urlFocusNode,
    required this.userNameFocusNode,
    required this.passwordFocusNode,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    ref.listen(createEnterpriseControllerProvider, (previous, next) {
      next.showAlertDialogOnError(context);
      next.showSnackbarOnSuccess(
        context,
        previous: previous,
        message: "Empresa cadastrada com sucesso".hardcoded,
      );
    });

    final enterpriseManagerAsync = ref.watch(
      enterpriseManagerControllerProvider,
    );
    return FloatingActionButton(
      onPressed: () {
        showModalPage(
          Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  autofocus: true,
                  controller: enterpriseNameController,
                  onFieldSubmitted: (_) {
                    urlFocusNode.requestFocus();
                  },

                  decoration: AppDecorations.input(
                    context: context,
                    hintText: "Nome da empresa".hardcoded,
                    suffixIcon: DeleteIcon(
                      onPress: enterpriseNameController.clear,
                    ),
                  ),
                ),
                gapH8,
                TextFormField(
                  controller: urlController,
                  focusNode: urlFocusNode,
                  onFieldSubmitted: (_) {
                    userNameFocusNode.requestFocus();
                  },
                  decoration: AppDecorations.input(
                    context: context,
                    hintText: "Url".hardcoded,
                    suffixIcon: DeleteIcon(onPress: urlController.clear),
                  ),
                ),
                gapH8,
                TextFormField(
                  controller: userNameController,
                  focusNode: userNameFocusNode,
                  onFieldSubmitted: (_) {
                    passwordFocusNode.requestFocus();
                  },
                  decoration: AppDecorations.input(
                    context: context,
                    hintText: "Nome do usuário".hardcoded,
                    suffixIcon: DeleteIcon(onPress: userNameController.clear),
                  ),
                ),
                gapH8,
                TextFormField(
                  controller: passwordController,
                  focusNode: passwordFocusNode,
                  onFieldSubmitted: (_) {
                    onSubmit();
                  },
                  decoration: AppDecorations.input(
                    context: context,
                    hintText: "Senha".hardcoded,
                    suffixIcon: DeleteIcon(onPress: passwordController.clear),
                  ),
                  obscureText: true,
                ),
                gapH32,
                PrimaryButton(
                  text: "Adicionar".hardcoded,
                  onPressed: onSubmit,
                  isLoading: enterpriseManagerAsync.isLoading,
                ),
              ],
            ),
          ),
          context,
        );
      },
      child: Icon(
        theme.platform == TargetPlatform.iOS ? CupertinoIcons.add : Icons.add,
      ),
    );
  }
}
