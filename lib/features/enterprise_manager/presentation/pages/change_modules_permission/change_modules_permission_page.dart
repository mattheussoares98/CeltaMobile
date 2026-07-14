import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/enterprise_manager/domain/entities/entities.dart';
import 'package:celta_inventario/features/enterprise_manager/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/enterprise_manager/presentation/pages/change_modules_permission/components/components.dart';
import 'package:celta_inventario/features/enterprise_manager/providers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final remoteHttpUrlController = TextEditingController();
  final localHttpUrlController = TextEditingController();
  final localHttpsUrlController = TextEditingController();
  final remoteHttpsUrlController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    remoteHttpUrlController.dispose();
    localHttpUrlController.dispose();
    localHttpsUrlController.dispose();
    remoteHttpsUrlController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final enterprise = await ref.read(
          enterprisePermissionsProvider(widget.enterpriseId).future,
        );

        remoteHttpUrlController.text = enterprise?.remoteHttpUrl ?? '';
        remoteHttpsUrlController.text = enterprise?.remoteHttpsUrl ?? '';
        localHttpUrlController.text = enterprise?.localHttpUrl ?? '';
        localHttpsUrlController.text = enterprise?.localHttpsUrl ?? '';
      }
    });
  }

  String getEnterpriseName(
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
      next.showToastOnSuccess(
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

    return BaseScaffold(
      isScrollable: false,
      appBar: BaseAppBar(
        title: isGlobalChange
            ? 'Permissões globais'.hardcoded
            : 'Permissões específicas'.hardcoded,

        actions: [
          if (enterpriseAsync.hasValue)
            SaveButton(
              enterpriseId: widget.enterpriseId,
              subEnterpriseId: widget.subEnterpriseId,
              permissionChanges: _permissionChanges,
              remoteHttpUrlController: remoteHttpUrlController,
              localHttpUrlController: localHttpUrlController,
              localHttpsUrlController: localHttpsUrlController,
              remoteHttpsUrlController: remoteHttpsUrlController,
              formKey: formKey,
              isGlobalChange: isGlobalChange,
            ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          return AsyncValueWidget(
            tryAgain: () => ref.invalidate(enterprisePermissionsProvider),
            value: enterpriseAsync,
            data: (enterprise) {
              if (enterprise == null) {
                return Center(
                  child: BaseText('Empresa não encontrada.'.hardcoded),
                );
              }
              final modulesToDisplay = _getModulesForScope(enterprise);
              final scopeName = getEnterpriseName(
                isGlobalChange,
                enterprise,
              ).toUpperCase();

              return CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: BaseText.titleMedium(
                      scopeName,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  gapSliverH16,
                  if (isGlobalChange) ...[
                    SliverToBoxAdapter(
                      child: Form(
                        key: formKey,
                        child: UrlsFields(
                          remoteHttpUrlController: remoteHttpUrlController,
                          remoteHttpsUrlController: remoteHttpsUrlController,
                          localHttpUrlController: localHttpUrlController,
                          localHttpsUrlController: localHttpsUrlController,
                        ),
                      ),
                    ),
                    EditEnterpriseSwitch(
                      onChange: (moduleId, newValue) {
                        setState(() => _permissionChanges[moduleId] = newValue);
                      },
                      modulesToDisplay: modulesToDisplay,
                      permissionChanges: _permissionChanges,
                    ),
                  ] else
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
    return enterprise.globalModules..sort((a, b) => a.name.compareTo(b.name));
  }
}
