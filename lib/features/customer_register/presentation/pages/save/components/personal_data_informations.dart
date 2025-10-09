import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';

class PersonalDataInformations extends StatelessWidget {
  const PersonalDataInformations({
    super.key,
    required this.customer,
    required this.passwordController,
  });

  final CustomerEntity? customer;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
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

            if (customer?.DateOfBirth != null)
              TitleAndSubTitle(
                title: 'Nascimento '.hardcoded,
                subTitle: DateFormat(
                  'dd/MM/yyyy',
                ).format(customer!.DateOfBirth!),
              ),
            if (passwordController.text.isNotEmpty)
              TitleAndSubTitle(
                title: 'Senha '.hardcoded,
                subTitle: List.generate(
                  passwordController.text.length,
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
