import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/buy_request/presentation/pages/components/components.dart';
import 'package:celta_inventario/features/buy_request/presentation/pages/confirmation/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfirmationPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  const ConfirmationPage({super.key, required this.enterpriseCode});

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
    ref.listen(insertBuyRequestControllerProvider(widget.enterpriseCode), (
      p,
      n,
    ) {
      n.showAlertDialogOnError(context);
    });

    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: BaseTextFormField(
            controller: observationsController,
            hintText: 'Observações'.hardcoded,
            labelText: 'Observações'.hardcoded,
            maxLines: 4,
            maxLength: 500,
          ),
        ),
        SliverToBoxAdapter(
          child: BuyersAndRequestsDropdown(
            enabled: false,
            enterpriseCode: widget.enterpriseCode,
          ),
        ),
        gapSliverH8,
        SelectedSupplier(enterpriseCode: widget.enterpriseCode),
        SelectedEnterprisesQuantity(enterpriseCode: widget.enterpriseCode),
        SelectedEnterprise(enterpriseCode: widget.enterpriseCode),
        InformedProductsQuantity(enterpriseCode: widget.enterpriseCode),
        InformedProducts(enterpriseCode: widget.enterpriseCode),
        gapSliverH32,
      ],
    );
  }
}
