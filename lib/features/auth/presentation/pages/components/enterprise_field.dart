import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/auth/presentation/controllers/controllers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnterpriseField extends ConsumerWidget {
  final TextEditingController enterpriseController;
  final FocusNode userFocusNode;
  const EnterpriseField({
    super.key,
    required this.enterpriseController,
    required this.userFocusNode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(
      loginControllerProvider.select((s) => s.isLoading),
    );

    return BaseTextFormField(
      controller: enterpriseController,
      enabled: !isLoading,
      labelText: context.l10n.enterprise,
      maxLength: 25,
      prefixIcon: PlatformIcon(
        cupertinoIcon: CupertinoIcons.building_2_fill,
        materialIcon: Icons.business,
        color: isLoading ? context.theme.disabledColor : null,
      ),
      textInputAction: TextInputAction.next,
      validator: FormValidators.compose([
        NonEmptyValidator(errorMessage: context.l10n.requiredField),
      ]),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: (_) => userFocusNode.requestFocus(),
    );
  }
}
