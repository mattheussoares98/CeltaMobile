import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../controllers/controllers.dart';
import '../identification/components/components.dart';
import 'components/components.dart';

class ConfirmationPage extends ConsumerStatefulWidget {
  const ConfirmationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfirmationPageState();
}

class _ConfirmationPageState extends ConsumerState<ConfirmationPage> {
  final observationsController = TextEditingController();

  @override
  void dispose() {
    observationsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final pendingAsync = ref.watch(pendingBuyRequestStateControllerProvider);
    ref.listen(insertBuyRequestControllerProvider, (p, n) {
      n.showAlertDialogOnError(context);
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  CleanAllDataButton(
                    observationsController: observationsController,
                  ),
                  const LastSavedRequestsNumbers(),
                  SliverToBoxAdapter(
                    child: DefaultTextFormField(
                      controller: observationsController,
                      hintText: 'Observações'.hardcoded,
                      labelText: 'Observações'.hardcoded,
                      maxLines: 4,
                    ),
                  ),
                  gapSliverH8,
                  const BuyersDropdown(enabled: false),
                  gapSliverH8,
                  const RequestTypeDropdown(enabled: false),
                  gapSliverH8,
                  const SelectedSupplier(),
                  const SelectedEnterprise(),
                  const InformedProducts(),
                ],
              ),
            ),
            Footer(observationsController: observationsController),
          ],
        ),
      ),
    );
  }
}
