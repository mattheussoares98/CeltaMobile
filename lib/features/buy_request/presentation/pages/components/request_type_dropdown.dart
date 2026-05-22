import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/request_type/request_type.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/buy_request/presentation/pages/components/components.dart';

class RequestTypeDropdown extends ConsumerWidget {
  final bool enabled;
  final int enterpriseCode;
  const RequestTypeDropdown({
    super.key,
    this.enabled = true,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      value: ref.watch(
        requestTypeStateControllerProvider(Modules.buyRequest, enterpriseCode),
      ),
      tryAgain: () {
        ref.invalidate(
          requestTypeStateControllerProvider(
            Modules.buyRequest,
            enterpriseCode,
          ),
        );
      },
      data: (requests) {
        return _RequestDropdown(
          requests: requests,
          enabled: enabled,
          enterpriseCode: enterpriseCode,
        );
      },
    );
  }
}

class _RequestDropdown extends ConsumerWidget {
  final List<BSFRequestTypeEntity>? requests;
  final bool enabled;
  final int enterpriseCode;
  const _RequestDropdown({
    required this.requests,
    required this.enabled,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultSmallTitle(title: 'Modelo de pedido'.hardcoded),
        gapH4,
        Consumer(
          builder: (_, ref, _) {
            final selectedSaleRequest = ref.watch(
              pendingBuyRequestStateControllerProvider(
                enterpriseCode,
              ).select((s) => s.value?.selectedRequestType),
            );
            final hasSelectedEnterprises = ref.watch(
              pendingBuyRequestStateControllerProvider(enterpriseCode).select(
                (s) => s.value?.selectedEnterprises?.isNotEmpty ?? false,
              ),
            );

            void update(BSFRequestTypeEntity? request) {
              ref
                  .read(
                    pendingBuyRequestStateControllerProvider(
                      enterpriseCode,
                    ).notifier,
                  )
                  .updatePending(
                    selectedRequestType: request,
                    annulSelectedEnterprises: selectedSaleRequest != request,
                    annulProducts: selectedSaleRequest != request,
                  );
            }

            return DefaultSimpleDropDown<BSFRequestTypeEntity?>(
              onTap: (request) {
                if (hasSelectedEnterprises) {
                  showAlertDialog(
                    context: context,
                    title: 'Atenção!'.hardcoded,
                    content:
                        'Ao alterar o modelo, as empresas e produtos selecionados serão removidos'
                            .hardcoded,
                  );
                }
              },
              onChanged: enabled ? update : null,
              items: requests
                  ?.map(
                    (e) => DropdownMenuItem(
                      key: ValueKey(e),
                      value: e,
                      child: Center(child: Text(e.name ?? '')),
                    ),
                  )
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return 'Selecione um modelo'.hardcoded;
                }
                return null;
              },
              value: selectedSaleRequest,
              hint: 'Selecione'.hardcoded,
            );
          },
        ),
      ],
    );
  }
}
