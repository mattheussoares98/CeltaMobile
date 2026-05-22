import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/customer_register/presentation/controllers/controllers.dart';

class PersonalDataInformations extends ConsumerWidget {
  const PersonalDataInformations({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customer = ref.watch(customerStateControllerProvider).value;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (customer?.CpfCnpjNumber != null &&
                customer?.CpfCnpjNumber?.isNotEmpty == true)
              TitleAndSubTitle(
                title: 'CPF/CNPJ '.hardcoded,
                subTitle: customer?.CpfCnpjNumber,
              ),

            if (customer?.Name != null && customer?.Name?.isNotEmpty == true)
              TitleAndSubTitle(
                title: 'Nome '.hardcoded,
                subTitle: customer?.Name,
              ),

            if (customer?.ReducedName != null &&
                customer?.ReducedName?.isNotEmpty == true)
              TitleAndSubTitle(
                title: 'Nome reduzido '.hardcoded,
                subTitle: customer?.ReducedName,
              ),

            if (customer?.DateOfBirth != null &&
                customer!.DateOfBirth != DateTime(0001, 01, 01))
              TitleAndSubTitle(
                title: 'Nascimento '.hardcoded,
                subTitle: DateFormat(
                  'dd/MM/yyyy',
                ).format(customer.DateOfBirth!),
              ),
            if (customer?.Password != null && customer!.Password!.isNotEmpty)
              TitleAndSubTitle(
                title: 'Senha '.hardcoded,
                subTitle: List.generate(
                  customer.Password!.length,
                  (index) => '*',
                ).join(),
              ),
            if (customer?.SexType?.name != null &&
                customer?.CpfCnpjNumber?.length == 11)
              TitleAndSubTitle(
                title: 'Sexo '.hardcoded,
                subTitle: customer?.SexType?.name,
              ),
          ],
        ),
      ),
    );
  }
}
