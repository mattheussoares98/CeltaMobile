import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';

class Customer extends ConsumerWidget {
  final int saleRequestId;
  const Customer({super.key, required this.saleRequestId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customer = ref.watch(
      saleRequestDetailsStateControllerProvider(
        saleRequestId,
      ).select((s) => s.value?.collection.first.customer),
    );
    if (customer == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TitleAndSubTitle(
                title: 'Nome'.hardcoded,
                subTitle: customer.Name ?? '',
              ),
              if (customer.Code != null)
                TitleAndSubTitle(
                  title: 'Código'.hardcoded,
                  subTitle: customer.Code.toString(),
                ),
              if (customer.PersonType != null)
                TitleAndSubTitle(
                  title: 'Tipo'.hardcoded,
                  subTitle: customer.PersonType?.completeName,
                ),
              if (customer.CpfCnpjNumber != null)
                TitleAndSubTitle(
                  title: 'CPF/CNPJ'.hardcoded,
                  subTitle: customer.CpfCnpjNumber,
                ),
              if (customer.Emails != null)
                TitleAndSubTitle(
                  title: 'E-mails'.hardcoded,
                  subTitle: customer.Emails?.join(', '),
                ),
              if (customer.Telephones != null)
                TitleAndSubTitle(
                  title: 'Telefones'.hardcoded,
                  subTitle: customer.Telephones?.map(
                    (e) => '(${e.AreaCode}) ${e.PhoneNumber}',
                  ).join(', '),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
