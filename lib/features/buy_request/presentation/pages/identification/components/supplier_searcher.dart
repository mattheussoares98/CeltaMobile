import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/buy_request/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    final annulSelectedSupplier = ref.read(
      pendingBuyRequestStateControllerProvider(
        widget.enterpriseCode,
      ).select((s) => s.value?.selectedEnterprises?.isNotEmpty ?? false),
    );
    await ref
        .read(
          pendingBuyRequestStateControllerProvider(
            widget.enterpriseCode,
          ).notifier,
        )
        .updatePending(
          annulSelectedSupplier: annulSelectedSupplier,
          annulSelectedEnterprises: true,
          annulProducts: true,
        );

    await ref
        .read(supplierStateControllerProvider(widget.enterpriseCode).notifier)
        .load(supplierController.text);
  }

  void onSubmit() {
    final (hasSelectedEnterprisesOrProducts, selectedSupplier) = ref.read(
      pendingBuyRequestStateControllerProvider(widget.enterpriseCode).select(
        (s) => (
          (s.value?.selectedEnterprises?.isNotEmpty ?? false) ||
              (s.value?.products?.isNotEmpty ?? false),
          s.value?.selectedSupplier,
        ),
      ),
    );

    if (selectedSupplier != null && hasSelectedEnterprisesOrProducts) {
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
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(supplierStateControllerProvider(widget.enterpriseCode), (p, n) {
      n.showToastOnError(context, p);
      n.doOnSuccess(p, () {
        supplierController.clear();
      });
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultSmallTitle(title: 'Fornecedores'.hardcoded),
        gapH8,
        Form(
          key: formKey,
          child: Consumer(
            builder: (_, ref, _) {
              return BaseTextFormField(
                labelText: 'Fornecedor'.hardcoded,
                hintText: 'Fornecedor'.hardcoded,
                controller: supplierController,
                validator: FormValidators.compose([NonEmptyValidator()]),
                onFieldSubmitted: (_) => onSubmit(),
                prefixIcon: IconButton(
                  onPressed: supplierController.clear,
                  icon: const PlatformIcon(
                    cupertinoIcon: CupertinoIcons.delete,
                    materialIcon: Icons.delete,
                    color: Colors.red,
                  ),
                ),
                enabled: !ref.watch(
                  supplierStateControllerProvider(
                    widget.enterpriseCode,
                  ).select((s) => s.isLoading),
                ),
                suffixIcon: IconButton(
                  onPressed: onSubmit,
                  icon: const PlatformIcon(
                    cupertinoIcon: CupertinoIcons.search,
                    materialIcon: Icons.search,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
