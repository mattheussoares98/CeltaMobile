import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../domain/entities/entities.dart';
import '../../../providers.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class ChangeModulesPermissionPage extends ConsumerStatefulWidget {
  final int enterpriseId;
  final int? subEnterpriseId; // Use the ID for consistency

  const ChangeModulesPermissionPage({
    super.key,
    required this.enterpriseId,
    required this.subEnterpriseId,
  });

  @override
  ConsumerState<ChangeModulesPermissionPage> createState() =>
      _ChangeModulesPermissionPageState();
}

class _ChangeModulesPermissionPageState
    extends ConsumerState<ChangeModulesPermissionPage> {
  Map<int, bool?> _permissionChanges = {};

  String getScopeName(
    bool isGlobalChange,
    EnterprisePermissionEntity enterprise,
  ) {
    if (isGlobalChange) {
      return enterprise.name;
    } else {
      final subEnterprise = enterprise.subEnterprises.firstWhere(
        (se) => se.id == widget.subEnterpriseId,
      );
      return '${subEnterprise.personalizedCode} - ${subEnterprise.name}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final enterpriseAsync = ref.watch(
      enterprisePermissionsProvider(widget.enterpriseId),
    );

    ref.listen<AsyncValue<EnterprisePermissionEntity?>>(
      enterprisePermissionsProvider(widget.enterpriseId),
      (previous, next) {
        if (next.hasValue && next.value != null && _permissionChanges.isEmpty) {
          final allModules = _getModulesForScope(next.value!);
          setState(() {
            _permissionChanges = {
              for (var module in allModules) module.id: module.isEnabled,
            };
          });
        }
      },
    );

    // Listen to the action provider to show feedback and pop the page
    ref.listen(updatePermissionsControllerProvider, (previous, next) {
      next.showAlertDialogOnError(context);
      next.showSnackbarOnSuccess(
        context,
        previous: previous,
        message: 'Permissões alteradas com sucesso'.hardcoded,
      );
      next.doOnSuccess(previous, () {
        ref.invalidate(enterprisePermissionsProvider);
        Navigator.of(context).pop();
      });
    });

    final isGlobalChange = widget.subEnterpriseId == null;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Text(
            isGlobalChange
                ? 'Permissões globais'.hardcoded
                : 'Permissões específicas'.hardcoded,
          ),
        ),
        actions: [
          if (enterpriseAsync.hasValue)
            SaveButton(
              enterpriseId: widget.enterpriseId,
              subEnterpriseId: widget.subEnterpriseId,
              permissionChanges: _permissionChanges,
            ),
        ],
      ),
      body: AsyncValueWidget(
        tryAgain: () => ref.invalidate(enterprisePermissionsProvider),
        value: enterpriseAsync,
        data: (enterprise) {
          if (enterprise == null) {
            return Center(child: Text('Empresa não encontrada.'.hardcoded));
          }
          final modulesToDisplay = _getModulesForScope(enterprise);
          final scopeName = getScopeName(
            isGlobalChange,
            enterprise,
          ).toUpperCase();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(scopeName, style: theme.textTheme.titleMedium),
              gapH16,
              if (isGlobalChange)
                EditEnterpriseSwitch(
                  onChange: (moduleId, newValue) {
                    setState(() => _permissionChanges[moduleId] = newValue);
                  },
                  modulesToDisplay: modulesToDisplay,
                  permissionChanges: _permissionChanges,
                )
              else
                EditSubEnterprisesSegmentedButttons(
                  onChange: (moduleId, newValue) {
                    setState(() => _permissionChanges[moduleId] = newValue);
                  },
                  modulesToDisplay: modulesToDisplay,
                  permissionChanges: _permissionChanges,
                ),
            ],
          );
        },
      ),
    );
  }

  List<ModulePermissionEntity> _getModulesForScope(
    EnterprisePermissionEntity enterprise,
  ) {
    if (widget.subEnterpriseId != null) {
      return enterprise.subEnterprises
          .firstWhere((se) => se.id == widget.subEnterpriseId)
          .modules;
    }
    return enterprise.globalModules;
  }
}
