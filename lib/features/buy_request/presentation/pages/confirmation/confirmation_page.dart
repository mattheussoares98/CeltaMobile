import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../controllers/controllers.dart';
import '../components/components.dart';
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
      floatingActionButton: FloatingSaveButton(
        observationsController: observationsController,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: DefaultTextFormField(
                controller: observationsController,
                hintText: 'Observações'.hardcoded,
                labelText: 'Observações'.hardcoded,
                maxLines: 4,
                maxLength: 500,
              ),
            ),
            const SliverToBoxAdapter(
              child: BuyersAndRequestsDropdown(enabled: false),
            ),
            gapSliverH8,
            const SelectedSupplier(),
            const SelectedEnterprisesQuantity(),
            const SelectedEnterprise(),
            const InformedProductsQuantity(),
            const InformedProducts(),
            gapSliverH48,
          ],
        ),
      ),
    );
  }
}
