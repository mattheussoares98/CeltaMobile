import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';

class SearchFieldAndSwitch extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController searchController;
  final int enterpriseCode;
  const SearchFieldAndSwitch({
    super.key,
    required this.formKey,
    required this.searchController,
    required this.enterpriseCode,
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
        .read(customersStateControllerProvider(widget.enterpriseCode).notifier)
        .loadCustomer(widget.searchController.text, searchByPersonalizedCode);
  }

  @override
  Widget build(BuildContext context) {

    ref.listen(customersStateControllerProvider(widget.enterpriseCode), (p, n) {
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
            labelText: 'Pesquisar cliente'.hardcoded,
            hintText: searchByPersonalizedCode
                ? 'Cód personalizado'
                : 'Nome | CPF | CNPJ | Código'.hardcoded,
            maxLength: 50,
            validator: FormValidators.compose([NonEmptyValidator()]),
            onFieldSubmitted: (_) => searchCustomer(),
            prefixIcon: IconButton(
              onPressed: widget.searchController.clear,
              icon: const PlatformIcon(
                cupertinoIcon: CupertinoIcons.delete,
                materialIcon: Icons.delete,
                color: Colors.red,
              ),
            ),
            suffixIcon: IconButton(
              onPressed: searchCustomer,
              icon: const PlatformIcon(
                cupertinoIcon: CupertinoIcons.search,
                materialIcon: Icons.search,
              ),
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
