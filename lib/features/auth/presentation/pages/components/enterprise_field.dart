import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/features/auth/presentation/controllers/controllers.dart';

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
    final theme = Theme.of(context);
    final isLoading = ref.watch(
      loginControllerProvider.select((s) => s.isLoading),
    );

    return DefaultTextFormField(
      controller: enterpriseController,
      enabled: !isLoading,
      labelText: 'Empresa'.hardcoded,
      maxLength: 25,
      prefixIcon: PlatformIcon(
        cupertinoIcon: CupertinoIcons.building_2_fill,
        materialIcon: Icons.business,
        color: isLoading ? theme.disabledColor : null,
      ),
      textInputAction: TextInputAction.next,
      validator: FormValidators.compose([NonEmptyValidator()]),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: (_) => userFocusNode.requestFocus(),
    );
  }
}
