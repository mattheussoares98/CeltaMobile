import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchCustomerField extends ConsumerStatefulWidget {
  const SearchCustomerField({super.key});

  @override
  ConsumerState<SearchCustomerField> createState() =>
      _SearchCustomerFieldState();
}

class _SearchCustomerFieldState extends ConsumerState<SearchCustomerField> {
  final searchController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Consumer(
        builder: (_, ref, _) {
          final searchByPersonalizedCode = ref.watch(
            searchedCustomersStateControllerProvider.select(
              (s) => s.value?.searchByPersonalizedCode == true,
            ),
          );
          return DefaultTextFormField(
            controller: searchController,
            labelText: 'Pesquisar'.hardcoded,
            hintText: searchByPersonalizedCode
                ? 'Código personalizado'.hardcoded
                : 'Nome|Cód|CPF/CNPJ',
            validator: FormValidators.compose([MinLengthValidator(3)]),
            onFieldSubmitted: (value) async {
              if (formKey.currentState?.validate() != true) {
                return;
              }

              final succeeds = await ref
                  .read(searchedCustomersStateControllerProvider.notifier)
                  .loadCustomer(value);
              if (succeeds) {
                searchController.clear();
              }
            },
          );
        },
      ),
    );
  }
}
