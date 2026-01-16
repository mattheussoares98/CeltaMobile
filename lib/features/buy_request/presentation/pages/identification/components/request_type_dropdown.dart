import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/request_type/request_type.dart';
import '../../../../domain/entities/entities.dart';
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
                  final pendingAsync = ref.watch(
                    pendingBuyRequestStateControllerProvider,
                  );
                  final pendingValue = pendingAsync.value;

                  void update(RequestTypeEntity? request) {
                    if (request == pendingValue?.selectedRequestType) {
                      return;
                    }
                    final entity =
                        (pendingValue ?? PendingBuyRequestEntity.empty())
                            .copyWith(selectedRequestType: request)
                            .annulValue(
                              annulSelectedEnterprises: true,
                              annulProducts: true,
                            );
                    ref
                        .read(pendingBuyRequestStateControllerProvider.notifier)
                        .updatePending(entity);

                    ref.invalidate(enterprisesStateControllerProvider);
                  }

                  return DefaultSimpleDropDown<RequestTypeEntity?>(
                    onTap: (request) {
                      if (pendingValue?.selectedEnterprises?.isNotEmpty ==
                          true) {
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
                    value: pendingValue?.selectedRequestType,
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
