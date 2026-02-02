import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/supplier/supplier.dart';
import '../../../../../../core/validators/validators.dart';
import '../../../controllers/controllers.dart';
import '../../components/components.dart';

class SupplierSearcher extends ConsumerStatefulWidget {
  final int enterpriseCode;
  const SupplierSearcher({super.key, required this.enterpriseCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SupplierItemsState();
}

class _SupplierItemsState extends ConsumerState<SupplierSearcher> {
  final formKey = GlobalKey<FormState>();
  final supplierController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    supplierController.dispose();
  }

  Future<void> loadSuppliers() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    await ref
        .read(
          pendingBuyRequestStateControllerProvider(
            widget.enterpriseCode,
          ).notifier,
        )
        .updatePending(
          annulSelectedSupplier: true,
          annulSelectedEnterprises: true,
          annulProducts: true,
        );

    await ref
        .read(
          supplierStateControllerProvider(
            SearchSupplierType.buyRequest,
            widget.enterpriseCode,
          ).notifier,
        )
        .load(supplierController.text);
  }

  @override
  Widget build(BuildContext context) {
    final hasSelectedEnterprisesOrProducts = ref.watch(
      pendingBuyRequestStateControllerProvider(widget.enterpriseCode).select(
        (s) =>
            (s.value?.selectedEnterprises?.isNotEmpty ?? false) ||
            (s.value?.products?.isNotEmpty ?? false),
      ),
    );

    ref.listen(
      supplierStateControllerProvider(
        SearchSupplierType.buyRequest,
        widget.enterpriseCode,
      ),
      (p, n) {
        n.showSnackbarOnError(context, p);
        n.doOnSuccess(p, () {
          supplierController.clear();
        });
      },
    );

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultSmallTitle(title: 'Fornecedores'.hardcoded),
        gapH8,
        Consumer(
          builder: (_, ref, _) {
            final selectedSupplier = ref.watch(
              pendingBuyRequestStateControllerProvider(
                widget.enterpriseCode,
              ).select((s) => s.value?.selectedSupplier),
            );

            return Form(
              key: formKey,
              child: DefaultTextFormField(
                labelText: 'Fornecedor'.hardcoded,
                hintText: 'Fornecedor'.hardcoded,
                controller: supplierController,
                maxLength: 50,
                validator: FormValidators.compose([NonEmptyValidator()]),
                onFieldSubmitted: (value) {
                  if (selectedSupplier != null &&
                      hasSelectedEnterprisesOrProducts) {
                    showAlertDialog(
                      context: context,
                      title: 'Consultar fornecedores?'.hardcoded,
                      content:
                          'Ao consultar os fornecedores, todas empresas e produtos selecionados serão removidos!'
                              .hardcoded,
                      cancelActionText: 'Cancelar'.hardcoded,
                      defaultActionText: 'Consultar'.hardcoded,
                      onOkPressed: loadSuppliers,
                    );
                  } else {
                    loadSuppliers();
                  }
                },
                prefixIcon: IconButton(
                  onPressed: () {
                    supplierController.clear();
                  },
                  icon: Icon(
                    isIOS ? CupertinoIcons.delete : Icons.delete,
                    color: Colors.red,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: loadSuppliers,
                  icon: Icon(isIOS ? CupertinoIcons.search : Icons.search),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
