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
  final AsyncValue<List<RequestTypeEntity>?> requestsState;
  const RequestTypeDropdown({super.key, required this.requestsState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingBuyRequestStateControllerProvider);

    return AsyncValueWidget(
      value: requestsState,
      tryAgain: () {
        ref.invalidate(requestTypeStateControllerProvider(Modules.buyRequest));
      },
      data: (requests) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultSmallTitle(title: 'Modelo de pedido'.hardcoded),
            gapH4,
            DefaultSimpleDropDown<RequestTypeEntity?>(
              onChanged: (request) {
                ref
                    .read(pendingBuyRequestStateControllerProvider.notifier)
                    .updatePending(
                      (pendingAsync.value ?? PendingBuyRequestEntity.empty())
                          .copyWith(selectedRequestType: request),
                    );
              },
              items: requests
                  ?.map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Center(child: Text(e.Name)),
                    ),
                  )
                  .toList(),
              value: pendingAsync.value?.selectedRequestType,
              hint: 'Selecionar'.hardcoded,
              isLoading: requestsState.isLoading,
            ),
          ],
        );
      },
    );
  }
}
