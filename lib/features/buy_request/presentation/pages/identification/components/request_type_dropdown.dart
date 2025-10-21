import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../enterprise_manager/domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import '../../components/components.dart';

class RequestTypeDropdown extends ConsumerWidget {
  final AsyncValue<List<RequestTypeEntity>?> requestsState;
  const RequestTypeDropdown({super.key, required this.requestsState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            DefaultDropDown<RequestTypeEntity>(
              onChanged: (request) {
                //TODO change selectedRequest
              },
              items: requests
                  ?.map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Center(child: Text(e.Name)),
                    ),
                  )
                  .toList(),
              selectedItem: null, //TODO add selectedRequest
              hint: Text('Selecionar'.hardcoded),
              label: 'Modelo de pedido'.hardcoded,
            ),
          ],
        );
      },
    );
  }
}
