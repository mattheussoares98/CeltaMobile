import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../domain/entities/entities.dart';
import '../../../providers.dart';
import '../../controllers/controllers.dart';

class ChangeModulesPermissionPage extends ConsumerStatefulWidget {
  final int enterpriseId;
  final String? cnpj; // Use the ID for consistency

  const ChangeModulesPermissionPage({
    super.key,
    required this.enterpriseId,
    this.cnpj,
  });

  @override
  ConsumerState<ChangeModulesPermissionPage> createState() =>
      _ChangeModulesPermissionPageState();
}

class _ChangeModulesPermissionPageState
    extends ConsumerState<ChangeModulesPermissionPage> {
  // 1. A local variable to store the "draft" changes.
  Map<int, bool?> _permissionChanges = {};

  @override
  Widget build(BuildContext context) {
    // Provider for the initial data load
    final enterpriseAsync = ref.watch(
      enterprisePermissionsProvider(widget.enterpriseId),
    );

    // Provider for the "Save" button's loading/error state
    final updateActionState = ref.watch(updatePermissionsControllerProvider);

    // Listen to the data provider to initialize our local state map ONCE
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
      // You can add error handling here too (e.g., using your AsyncValueUI extension)
    });

    final isGlobalChange = widget.cnpj == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isGlobalChange
              ? 'Permissões Globais'.hardcoded
              : 'Permissões Específicas'.hardcoded,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: updateActionState.isLoading
            ? null
            : () {
                ref
                    .read(updatePermissionsControllerProvider.notifier)
                    .saveChanges(
                      enterpriseId: widget.enterpriseId,
                      subEnterpriseId: int.tryParse(widget.cnpj ?? ""),
                      changes: _permissionChanges,
                    );
              },
        label: Text('Salvar'.hardcoded),
        icon: updateActionState.isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              )
            : const Icon(Icons.save),
      ),
      body: AsyncValueWidget(
        tryAgain: () => ref.invalidate(enterprisePermissionsProvider),
        value: enterpriseAsync,
        data: (enterprise) {
          if (enterprise == null) {
            return Center(child: Text('Empresa não encontrada.'.hardcoded));
          }
          final modulesToDisplay = _getModulesForScope(enterprise);
          final scopeName = isGlobalChange
              ? enterprise.name
              : enterprise.subEnterprises
                    .firstWhere((se) => se.id == int.parse(widget.cnpj!))
                    .name;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text(
                'Editando: $scopeName',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              ...modulesToDisplay.map((module) {
                final currentValue = _permissionChanges[module.id];

                // If it's a GLOBAL change, show a simple Switch
                if (isGlobalChange) {
                  return SwitchListTile(
                    title: Text(module.name),
                    value: currentValue ?? false, // Default global to false
                    onChanged: (newValue) {
                      setState(() => _permissionChanges[module.id] = newValue);
                    },
                  );
                }
                // If it's a SPECIFIC CNPJ change, show the SegmentedButton
                else {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          module.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        SegmentedButton<bool?>(
                          segments: [
                            ButtonSegment(
                              value: true,
                              label: Text('Habilitado'.hardcoded),
                            ),
                            ButtonSegment(
                              value: null,
                              label: Text('Herdar'.hardcoded),
                            ),
                            ButtonSegment(
                              value: false,
                              label: Text('Desabilitado'.hardcoded),
                            ),
                          ],
                          selected: {currentValue},
                          onSelectionChanged: (newSelection) {
                            setState(
                              () => _permissionChanges[module.id] =
                                  newSelection.first,
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.resolveWith<Color>((
                                  states,
                                ) {
                                  if (states.contains(WidgetState.selected)) {
                                    if (currentValue == true) {
                                      return Colors.green.shade100;
                                    }
                                    if (currentValue == false) {
                                      return Colors.red.shade100;
                                    }
                                    return Colors.blue.shade100;
                                  }
                                  return Colors.transparent;
                                }),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }),
            ],
          );
        },
      ),
    );
  }

  List<ModulePermissionEntity> _getModulesForScope(
    EnterprisePermissionEntity enterprise,
  ) {
    if (widget.cnpj != null) {
      return enterprise.subEnterprises
          .firstWhere((se) => se.id == int.parse(widget.cnpj!))
          .modules;
    }
    return enterprise.subEnterprises.isNotEmpty
        ? enterprise.subEnterprises.first.modules
        : [];
  }
}
