import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../controllers/controllers.dart';

class SearchFieldAndSwitch extends ConsumerStatefulWidget {
  const SearchFieldAndSwitch({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchFieldAndSwitchState();
}

class _SearchFieldAndSwitchState extends ConsumerState<SearchFieldAndSwitch> {
  final searchCustomerController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool searchByPersonalizedCode = false;

  @override
  void dispose() {
    searchCustomerController.dispose();
    super.dispose();
  }

  void onTapSwitch() {
    setState(() {
      searchByPersonalizedCode = !searchByPersonalizedCode;
    });
  }

  void searchCustomer() {
    if (formKey.currentState?.validate() != true) {
      return;
    }
    ref
        .read(customersStateControllerProvider.notifier)
        .loadCustomer(searchCustomerController.text, searchByPersonalizedCode);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    ref.listen(customersStateControllerProvider, (p, n) {
      n.doOnSuccess(p, () {
        searchCustomerController.clear();
      });
    });

    return Column(
      children: [
        Form(
          key: formKey,
          child: DefaultTextFormField(
            controller: searchCustomerController,
            labelText: searchByPersonalizedCode
                ? 'Cód personalizado'
                : 'Nome | CPF | CNPJ | Código'.hardcoded,
            hintText: searchByPersonalizedCode
                ? 'Cód personalizado'
                : 'Nome | CPF | CNPJ | Código'.hardcoded,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            maxLength: 50,
            validator: FormValidators.compose([NonEmptyValidator()]),
            onFieldSubmitted: (_) => searchCustomer(),
            prefixIcon: IconButton(
              onPressed: searchCustomerController.clear,
              icon: Icon(
                isIOS ? CupertinoIcons.delete : Icons.delete,
                color: Colors.red,
              ),
            ),
            suffixIcon: IconButton(
              onPressed: searchCustomer,
              icon: Icon(isIOS ? CupertinoIcons.search : Icons.search),
            ),
          ),
        ),
        gapH4,
        DefaultSwitch(
          title: 'Pesquisar pelo código personalizado',
          value: searchByPersonalizedCode,
          onChanged: (_) => onTapSwitch(),
        ),
        gapH8,
      ],
    );
  }
}
