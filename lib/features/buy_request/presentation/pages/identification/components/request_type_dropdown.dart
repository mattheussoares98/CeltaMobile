import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/request_type/request_type.dart';
import '../../../controllers/controllers.dart';
import '../../components/components.dart';

class RequestTypeDropdown extends ConsumerWidget {
  final bool enabled;
  const RequestTypeDropdown({super.key, this.enabled = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueSliverWidget(
      value: ref.watch(requestTypeStateControllerProvider(Modules.buyRequest)),
      tryAgain: () {
        ref.invalidate(requestTypeStateControllerProvider(Modules.buyRequest));
      },
      data: (requests) {
        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultSmallTitle(title: 'Modelo de pedido'.hardcoded),
              gapH4,
              Consumer(
                builder: (_, ref, _) {
                  final selectedSaleRequest = ref.watch(
                    pendingBuyRequestStateControllerProvider.select(
                      (s) => s.value?.selectedRequestType,
                    ),
                  );
                  final hasSelectedEnterprises = ref.watch(
                    pendingBuyRequestStateControllerProvider.select(
                      (s) => s.value?.selectedEnterprises?.isNotEmpty ?? false,
                    ),
                  );

                  void update(RequestTypeEntity? request) {
                    ref
                        .read(pendingBuyRequestStateControllerProvider.notifier)
                        .updatePending(
                          selectedRequestType: request,
                          annulSelectedEnterprises:
                              selectedSaleRequest != request,
                          annulProducts: selectedSaleRequest != request,
                        );
                  }

                  return DefaultSimpleDropDown<RequestTypeEntity?>(
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
                            key: ValueKey(e.Code),
                            value: e,
                            child: Center(child: Text(e.Name)),
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
          ),
        );
      },
    );
  }
}
