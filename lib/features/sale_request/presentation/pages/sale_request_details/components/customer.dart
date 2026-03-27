import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';

class Customer extends ConsumerWidget {
  final int saleRequestId;
  final int customerCode;
  final int enterpriseCode;
  const Customer({
    super.key,
    required this.saleRequestId,
    required this.customerCode,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestCustomer = ref.watch(
      saleRequestsStateControllerProvider(enterpriseCode).select(
        (s) => s.value?.collection
            .firstWhereOrNull((e) => e.Id == saleRequestId)
            ?.customer,
      ),
    );
    final detailsCustomer = ref.watch(
      saleRequestDetailsStateControllerProvider(
        customerCode: customerCode,
        enterpriseCode: enterpriseCode,
        saleRequestCode: saleRequestId,
      ).select((s) => s.value?.customer),
    );
    if (requestCustomer == null || detailsCustomer == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    final customerName = requestCustomer.Name ?? detailsCustomer.name;
    bool isInternalCustomer = customerName?.toLowerCase() == 'consumidor';
    final personalizedCode =
        requestCustomer.PersonalizedCode ?? detailsCustomer.personalizedCode;
    final cpfCnpj = requestCustomer.CpfCnpjNumber;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(isIOS ? CupertinoIcons.person : Icons.person),
            gapW8,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TitleAndSubTitle(
                    title: null,
                    subTitle:
                        '$customerName '
                        '${(isInternalCustomer || (personalizedCode?.isEmpty ?? true)) ? '' : "($personalizedCode)"}',
                  ),
                  if (requestCustomer.PersonType != null && !isInternalCustomer)
                    TitleAndSubTitle(
                      title: 'Tipo'.hardcoded,
                      subTitle: requestCustomer.PersonType?.completeName,
                    ),
                  if (cpfCnpj != null && !isInternalCustomer)
                    TitleAndSubTitle(
                      title: 'CPF/CNPJ'.hardcoded,
                      subTitle: cpfCnpj,
                    ),
                  if (requestCustomer.Emails != null)
                    TitleAndSubTitle(
                      title: 'E-mails'.hardcoded,
                      subTitle: requestCustomer.Emails?.join(', '),
                    ),
                  if (requestCustomer.Telephones != null)
                    TitleAndSubTitle(
                      title: 'Telefones'.hardcoded,
                      subTitle: requestCustomer.Telephones?.map(
                        (e) => '(${e.AreaCode}) ${e.PhoneNumber}',
                      ).join(', '),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
