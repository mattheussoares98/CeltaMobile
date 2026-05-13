import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
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

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: searchController,
      labelText: 'Pesquisar'.hardcoded,
      onFieldSubmitted: (value) async {
        final succeeds = await ref
            .read(searchedCustomersStateControllerProvider.notifier)
            .loadCustomer(value, false);
        if (succeeds) {
          searchController.clear();
        }
      },
    );
  }
}
