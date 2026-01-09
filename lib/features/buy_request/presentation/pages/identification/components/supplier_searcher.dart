import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
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
  final TextEditingController supplierController;
  const SupplierSearcher({super.key, required this.supplierController});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SupplierItemsState();
}

class _SupplierItemsState extends ConsumerState<SupplierSearcher> {
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pendingAsync = ref.watch(pendingBuyRequestStateControllerProvider);

    Future<void> loadSuppliers() async {
      if (formKey.currentState?.validate() != true) {
        return;
      }

      if (pendingAsync.value?.selectedSupplier != null) {
        ref
            .read(pendingBuyRequestStateControllerProvider.notifier)
            .updatePending(
              pendingAsync.value!.annulValue(
                annulSelectedSupplier: true,
                annulSelectedEnterprises: true,
                annulProducts: true,
              ),
            );
      }

      await ref
          .read(
            supplierStateControllerProvider(
              SearchSupplierType.buyRequest,
            ).notifier,
          )
          .load(widget.supplierController.text);
    }

    ref.listen(supplierStateControllerProvider(SearchSupplierType.buyRequest), (
      p,
      n,
    ) {
      n.showSnackbarOnError(context, p);
      n.doOnSuccess(p, () {
        widget.supplierController.clear();
      });
    });

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultSmallTitle(title: 'Fornecedores'.hardcoded),
          gapH8,
          Form(
            key: formKey,
            child: DefaultTextFormField(
              labelText: 'Fornecedor'.hardcoded,
              hintText: 'Fornecedor'.hardcoded,
              controller: widget.supplierController,
              maxLength: 50,
              validator: FormValidators.compose([NonEmptyValidator()]),
              onFieldSubmitted: (value) {
                bool hasSelectedEnterprises =
                    pendingAsync.value?.selectedEnterprises?.isNotEmpty ??
                    false;
                bool hasSelectedProducts =
                    pendingAsync.value?.products?.isNotEmpty ?? false;

                if (pendingAsync.value?.selectedSupplier != null &&
                    (hasSelectedEnterprises || hasSelectedProducts)) {
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
                  widget.supplierController.clear();
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
          ),
          gapH8,
          if (ref.watch(
            supplierStateControllerProvider(
              SearchSupplierType.buyRequest,
            ).select((s) => s.isLoading),
          ))
            const Center(child: LoadingWidget()),
        ],
      ),
    );
  }
}
