import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/customer_register/presentation/controllers/controllers.dart';

class SexDropDown extends ConsumerWidget {
  const SexDropDown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSex = ref.watch(
      customerStateControllerProvider.select((s) => s.value?.SexType),
    );

    void onChangeSex(CustomerSexType? value) => ref
        .read(customerStateControllerProvider.notifier)
        .updatePersonalData(SexType: value);

    return DefaultDropDown<CustomerSexType?>(
      selectedItem: selectedSex,
      label: 'Sexo'.hardcoded,
      isSimple: true,
      onChanged: onChangeSex,
      validator: (sex) {
        if (sex == null) {
          return 'Campo obrigatório'.hardcoded;
        }
        return null;
      },
      items: CustomerSexType.values
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Center(child: Text(e.name)),
            ),
          )
          .toList(),
    );
  }
}
