import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../controllers/controllers.dart';

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
      child: DefaultTextFormField(
        controller: searchController,
        labelText: 'Pesquisar'.hardcoded,
        validator: FormValidators.compose([MinLengthValidator(3)]),
        onFieldSubmitted: (value) async {
          if (formKey.currentState?.validate() != true) {
            return;
          }

          final succeeds = await ref
              .read(searchedCustomersStateControllerProvider.notifier)
              .loadCustomer(value, false);
          if (succeeds) {
            searchController.clear();
          }
        },
      ),
    );
  }
}
