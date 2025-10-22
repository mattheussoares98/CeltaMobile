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
      ref
          .read(pendingBuyRequestStateControllerProvider.notifier)
          .updatePending(
            (pendingValue ?? PendingBuyRequestEntity.empty()).copyWith(
              selectedRequestType: request,
            ),
          );
      ref.invalidate(enterprisesStateControllerProvider);
      //TODO invalidate products
    }

    bool needShowAlertDialog(RequestTypeEntity? request) {
      if (pendingValue?.selectedEnterprises == null) {
        return false;
      } else if (pendingValue!.selectedEnterprises!.isEmpty) {
        return false;
      } else if (pendingValue.selectedRequestType == null) {
        return false;
      } else if (pendingValue.selectedRequestType == request) {
        return false;
      }
      return true;
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
                onChanged: (request) {
                  if (needShowAlertDialog(request)) {
                    showAlertDialog(
                      context: context,
                      title: 'Atenção!'.hardcoded,
                      content:
                          'Ao alterar o modelo, as empresas e produtos selecionados serão removidos'
                              .hardcoded,
                      cancelActionText: 'Cancelar'.hardcoded,
                      onOkPressed: () {
                        update(request);
                      },
                    );
                  } else {
                    update(request);
                  }
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
                hint: 'Selecionar'.hardcoded,
                isLoading: requestsState.isLoading,
              ),
            ],
          ),
        );
      },
    );
  }
}
