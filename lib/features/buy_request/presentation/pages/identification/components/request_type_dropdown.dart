import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../enterprise_manager/domain/entities/entities.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import '../../components/components.dart';

class RequestTypeDropdown extends ConsumerWidget {
  const RequestTypeDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsState = ref.watch(
      requestTypeStateControllerProvider(Modules.buyRequest),
    );
    final pendingAsync = ref.watch(pendingBuyRequestStateControllerProvider);
    final pendingValue = pendingAsync.value;

    void update(RequestTypeEntity? request) {
      if (request == pendingValue?.selectedRequestType) {
        return;
      }
      final entity = (pendingValue ?? PendingBuyRequestEntity.empty())
          .copyWith(selectedRequestType: request)
          .annulValue(annulSelectedEnterprises: true, annulProducts: true);
      ref
          .read(pendingBuyRequestStateControllerProvider.notifier)
          .updatePending(entity);

      ref.invalidate(enterprisesStateControllerProvider);
    }

    return AsyncValueSliverWidget(
      value: requestsState,
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
              DefaultSimpleDropDown<RequestTypeEntity?>(
                onTap: (request) {
                  if (pendingValue?.selectedEnterprises?.isNotEmpty == true) {
                    showAlertDialog(
                      context: context,
                      title: 'Atenção!'.hardcoded,
                      content:
                          'Ao alterar o modelo, as empresas e produtos selecionados serão removidos'
                              .hardcoded,
                    );
                  }
                },
                onChanged: (request) {
                  update(request);
                },
                items: requests
                    ?.map(
                      (e) => DropdownMenuItem(
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
                isLoading: requestsState.isLoading,
              ),
            ],
          ),
        );
      },
    );
  }
}
