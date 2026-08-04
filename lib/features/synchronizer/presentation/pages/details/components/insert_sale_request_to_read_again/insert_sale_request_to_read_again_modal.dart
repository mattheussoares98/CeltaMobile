import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/enterprises/enterprises.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/extensions/extensions.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part './select_comerce_site_drop_down.dart';
part './select_enterprise_drop_down.dart';

class InsertSaleRequestToReadAgainModal extends ConsumerStatefulWidget {
  const InsertSaleRequestToReadAgainModal({super.key, required this.errorKey});
  final String errorKey;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InsertSaleRequestToReadAgainState();
}

class _InsertSaleRequestToReadAgainState
    extends ConsumerState<InsertSaleRequestToReadAgainModal> {
  EnterpriseEntity? selectedEnterprise;
  EcCommerceSiteEntity? selectedCommerceSite;
  final saleRequestIdController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    saleRequestIdController.dispose();
    super.dispose();
  }

  void onChangeEnterprise(EnterpriseEntity enterprise) {
    setState(() {
      selectedEnterprise = enterprise;
    });
  }

  void onChangeCommerceSite(EcCommerceSiteEntity commerceSite) {
    setState(() {
      selectedCommerceSite = commerceSite;
    });
  }

  Future<void> onSubmit() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    final succeeds = await ref
        .read(handleSelectedCodesControllerProvider.notifier)
        .insertSaleRequestsToReadAgain(
          widget.errorKey,
          enterpriseCode: selectedEnterprise!.Code!,
          enterpriseCommerceSiteCode: selectedCommerceSite!.code,
          saleRequestIds: [saleRequestIdController.text],
        );

    if (mounted && succeeds) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.observeLoading([handleSelectedCodesControllerProvider]);
    return BaseScaffold(
      body: Form(
        key: formKey,
        child: Column(
          children: [
            _SelectEnterpriseDropDown(
              onChangeEnterprise: onChangeEnterprise,
              selectedEnterprise: selectedEnterprise,
            ),
            gapH8,
            _SelectCommerceSiteDropDown(
              onChangeCommerceSite: onChangeCommerceSite,
              selectedCommerceSite: selectedCommerceSite,
              enterpriseCode: selectedEnterprise?.Code,
            ),
            gapH8,
            BaseTextFormField(
              controller: saleRequestIdController,
              hintText: 'ID do pedido'.hardcoded,
              labelText: 'ID do pedido'.hardcoded,
              validator: FormValidators.compose([NonEmptyValidator()]),
              onFieldSubmitted: (_) => onSubmit(),
            ),
            gapH8,
            AnimatedBuilder(
              animation: saleRequestIdController,
              builder: (context, _) {
                return PrimaryButton(
                  text: 'Inserir para releitura'.hardcoded,
                  onPressed:
                      selectedEnterprise == null ||
                          selectedCommerceSite == null ||
                          saleRequestIdController.text.isEmpty
                      ? null
                      : onSubmit,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
