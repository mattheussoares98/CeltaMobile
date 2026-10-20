import 'package:celta_inventario/localization/localization.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/customer_register/presentation/controllers/controllers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                title: context.l10n.cpfCnpj2,
                subTitle: customer?.CpfCnpjNumber,
              ),

            if (customer?.Name != null && customer?.Name?.isNotEmpty == true)
              TitleAndSubTitle(
                title: context.l10n.name2,
                subTitle: customer?.Name,
              ),

            if (customer?.ReducedName != null &&
                customer?.ReducedName?.isNotEmpty == true)
              TitleAndSubTitle(
                title: context.l10n.shortName,
                subTitle: customer?.ReducedName,
              ),

            if (customer?.DateOfBirth != null &&
                customer!.DateOfBirth != DateTime(0001))
              TitleAndSubTitle(
                title: context.l10n.birthDate,
                subTitle: customer.DateOfBirth?.formatDate(),
              ),
            if (customer?.Password != null && customer!.Password!.isNotEmpty)
              TitleAndSubTitle(
                title: context.l10n.password2,
                subTitle: List.generate(
                  customer.Password!.length,
                  (index) => '*',
                ).join(),
              ),
            if (customer?.SexType?.name != null &&
                customer?.CpfCnpjNumber?.length == 11)
              TitleAndSubTitle(
                title: context.l10n.sex,
                subTitle: customer?.SexType == null
                    ? null
                    : context.l10n.sexName(customer!.SexType!),
              ),
          ],
        ),
      ),
    );
  }
}
