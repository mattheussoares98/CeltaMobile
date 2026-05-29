import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/request_type/request_type.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestTypeDropDown extends ConsumerWidget {
  const RequestTypeDropDown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterpriseCode = ref.watch(
      saleRequestArgsProvider.select((s) => s.enterpriseCode),
    );

    final provider = requestTypeStateControllerProvider(
      Modules.saleRequest,
      enterpriseCode,
    );

    return Consumer(
      builder: (_, ref, _) {
        final selectedRequest = ref.watch(
          insertUpdateStateControllerProvider.select(
            (s) => s.value?.requestType,
          ),
        );
        return AsyncValueWidget(
          value: ref.watch(provider),
          tryAgain: () => ref.invalidate(provider),
          data: (requestTypes) {
            if (requestTypes?.isEmpty ?? true) return const SizedBox.shrink();

            return DefaultDropDown<BSFRequestTypeEntity>(
              showLabelAtTopLeft: true,
              label: 'Modelo de pedido'.hardcoded,
              selectedItem: selectedRequest,
              items: requestTypes!.map((requestType) {
                return DropdownMenuItem(
                  value: requestType,
                  child: Center(child: Text(requestType.name!)),
                );
              }).toList(),
              onBeforeChange: (requestType) =>
                  _handleBeforeChange(context, ref, requestType),
              onChanged: (requestType) {
                ref
                    .read(insertUpdateStateControllerProvider.notifier)
                    .updateRequestType(requestType, onlyValidating: false);
              },
            );
          },
        );
      },
    );
  }

  Future<bool> _handleBeforeChange(
    BuildContext context,
    WidgetRef ref,
    BSFRequestTypeEntity requestType,
  ) async {
    final notifier = ref.read(insertUpdateStateControllerProvider.notifier);

    final actions = notifier.updateRequestType(requestType, onlyValidating: true);

    if (actions.isNotEmpty) {
      final confirmed = await showAlertDialog(
        context: context,
        title: 'Alteração do modelo de pedido'.hardcoded,
        content:
            'Esta alteração terá os seguintes impactos no pedido:\n\n'
                    '${actions.map((a) => '• ${a.message}').join('\n')}\n\n'
                    'Deseja prosseguir?'
                .hardcoded,
        cancelActionText: 'Cancelar'.hardcoded,
        defaultActionText: 'Confirmar'.hardcoded,
      );

      return confirmed == true;
    }

    return true;
  }
}
