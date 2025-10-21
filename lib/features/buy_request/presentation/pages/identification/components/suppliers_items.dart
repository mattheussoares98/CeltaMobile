import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/validators/validators.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import '../../components/components.dart';
import 'components.dart';

class SuppliersItems extends ConsumerWidget {
  final TextEditingController supplierController;
  final AsyncValue<List<SupplierEntity>?> suppliersState;
  const SuppliersItems({
    super.key,
    required this.supplierController,
    required this.suppliersState,
  });

  static final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingBuyRequestStateControllerProvider);

    Future<void> loadSuppliers() async {
      if (formKey.currentState?.validate() != true) {
        return;
      }

      ref
          .read(pendingBuyRequestStateControllerProvider.notifier)
          .updatePending(
            (pendingAsync.value ?? PendingBuyRequestEntity.empty()).copyWith(
              selectedSupplier: null,
            ),
          );

      await ref
          .read(
            supplierStateControllerProvider(
              SearchSupplierType.buyRequest,
            ).notifier,
          )
          .load(supplierController.text);
    }

    ref.listen(supplierStateControllerProvider(SearchSupplierType.buyRequest), (
      p,
      n,
    ) {
      n.showSnackbarOnError(context, previous: p, message: n.error);
      n.doOnSuccess(p, () {
        supplierController.clear();
      });
    });

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultSmallTitle(title: 'Fornecedores'.hardcoded),
          gapH8,
          DefaultTextFormField(
            labelText: 'Fornecedor'.hardcoded,
            hintText: 'Fornecedor'.hardcoded,
            controller: supplierController,
            maxLength: 50,
            validator: FormValidators.compose([NonEmptyValidator()]),
            onFieldSubmitted: (value) {
              loadSuppliers();
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
          gapH8,
          if (pendingAsync.value?.selectedSupplier != null &&
              suppliersState.value == null)
            SupplierItem(
              supplier: pendingAsync.value!.selectedSupplier!,
              pending: pendingAsync.value,
            )
          else if (suppliersState.value != null)
            ListView.builder(
              shrinkWrap: true, //TODO change to CustomScrollView
              itemCount: suppliersState.value!.length,
              itemBuilder: (_, index) {
                final supplier = suppliersState.value![index];
                return SupplierItem(
                  supplier: supplier,
                  pending: pendingAsync.value,
                );
              },
            ),
        ],
      ),
    );
  }
}
