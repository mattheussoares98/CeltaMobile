import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Customer extends ConsumerWidget {
  final int enterpriseCode;
  const Customer({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ref.watch(saleRequestArgsProvider);

    final requestCustomer = ref.watch(
      saleRequestsStateControllerProvider(enterpriseCode).select(
        (s) => s.value?.collection
            .firstWhereOrNull((e) => e.Id == args.saleRequestId)
            ?.customer,
      ),
    );
    final detailsCustomer = ref.watch(
      saleRequestDetailsStateControllerProvider(
        ref.read(saleRequestArgsProvider),
      ).select((s) => s.value?.customer),
    );
    if (requestCustomer == null && detailsCustomer == null) {
      return const SizedBox.shrink();
    }

    final customerName = requestCustomer?.Name ?? detailsCustomer?.name;
    final customerCode = requestCustomer?.Code ?? detailsCustomer?.code;
    bool isInternalCustomer = customerName?.toLowerCase() == 'consumidor';
    final personalizedCode =
        requestCustomer?.PersonalizedCode ?? detailsCustomer?.personalizedCode;
    final cpfCnpj = requestCustomer?.CpfCnpjNumber;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PlatformIcon(
              cupertinoIcon: CupertinoIcons.person,
              materialIcon: Icons.person,
            ),
            gapW8,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TitleAndSubTitle(
                    title: customerCode == null || isInternalCustomer
                        ? null
                        : '(${customerCode.toString()})',
                    removeColon: true,
                    subTitle:
                        '$customerName '
                        '${(isInternalCustomer || (personalizedCode?.isEmpty ?? true)) ? '' : "($personalizedCode)"}',
                  ),
                  if (requestCustomer?.PersonType != null &&
                      !isInternalCustomer)
                    TitleAndSubTitle(
                      title: 'Tipo'.hardcoded,
                      subTitle: requestCustomer?.PersonType?.completeName,
                    ),
                  if (cpfCnpj != null && !isInternalCustomer)
                    TitleAndSubTitle(
                      title: 'CPF/CNPJ'.hardcoded,
                      subTitle: cpfCnpj,
                    ),
                  if (requestCustomer?.Emails?.isNotEmpty ?? false)
                    TitleAndSubTitle(
                      title: 'E-mails'.hardcoded,
                      subTitle: requestCustomer?.Emails?.join(', '),
                    ),
                  if (requestCustomer?.Telephones?.isNotEmpty ?? false)
                    TitleAndSubTitle(
                      title: 'Telefones'.hardcoded,
                      subTitle: requestCustomer?.Telephones
                          ?.map((e) => '(${e.AreaCode}) ${e.PhoneNumber}')
                          .join(', '),
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
