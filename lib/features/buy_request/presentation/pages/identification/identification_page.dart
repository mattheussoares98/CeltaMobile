import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../enterprise_manager/domain/entities/entities.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class IdentificationPage extends ConsumerWidget {
  const IdentificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buyersState = ref.watch(buyersStateControllerProvider);
    final requestsState = ref.watch(
      requestTypeStateControllerProvider(Modules.buyRequest),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Identificação'.hardcoded)),
      body: ResponsiveScrollableWidget(
        child: Column(
          children: [
            BuyersDropdown(buyersState: buyersState),
            gapH8,
            RequestTypeDropdown(requestsState: requestsState),
            gapH8,
          ],
        ),
      ),
    );
  }
}
