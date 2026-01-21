import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/validators/validators.dart';
import '../../../../controllers/controllers.dart';

class SearchFieldAndSwitch extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController searchController;
  const SearchFieldAndSwitch({
    super.key,
    required this.formKey,
    required this.searchController,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchFieldAndSwitchState();
}

class _SearchFieldAndSwitchState extends ConsumerState<SearchFieldAndSwitch> {
  bool searchByPersonalizedCode = false;

  void onTapSwitch() {
    setState(() {
      searchByPersonalizedCode = !searchByPersonalizedCode;
    });
  }

  void searchCustomer() {
    if (widget.formKey.currentState?.validate() != true) {
      return;
    }
    ref
        .read(customersStateControllerProvider.notifier)
        .loadCustomer(widget.searchController.text, searchByPersonalizedCode);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    ref.listen(customersStateControllerProvider, (p, n) {
      n.doOnSuccess(p, () {
        widget.searchController.clear();
      });
    });

    return Column(
      children: [
        Form(
          key: widget.formKey,
          child: DefaultTextFormField(
            controller: widget.searchController,
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
              onPressed: widget.searchController.clear,
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
