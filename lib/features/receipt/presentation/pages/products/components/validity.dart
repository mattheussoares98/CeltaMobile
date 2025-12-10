import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';

class Validity extends ConsumerWidget {
  final ProductEntity product;
  final SearchProductKey searchProductKey;
  final int receiptCode;
  const Validity({
    super.key,
    required this.product,
    required this.searchProductKey,
    required this.receiptCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    final now = DateTime.now();

    return Row(
      children: [
        Expanded(
          child: TitleAndSubTitle(
            title: 'Validade'.hardcoded,
            subTitle: product.DataValidade_ProcRecebDocProEmb == null
                ? null
                : DateFormat(
                    'dd/MM/yyyy',
                  ).format(product.DataValidade_ProcRecebDocProEmb!),
            emptyMessage: 'Sem validade'.hardcoded,
          ),
        ),
        Consumer(
          builder: (_, ref, _) {
            final isLoading = ref.watch(
              updateProductControllerProvider(
                searchProductKey,
              ).select((s) => s.isLoading),
            );
            return PrimaryTextButton(
              text: 'Alterar',
              isLoading: isLoading,
              icon: Icon(
                isIOS ? CupertinoIcons.calendar : Icons.calendar_month,
              ),
              onPressed: () async {
                final newDate = await GetNewDate.get(
                  minimumDate: now,
                  currentSelectedDate: product.DataValidade_ProcRecebDocProEmb,
                  insertHoursAndMinutes: false,
                  maximumDate: now.add(const Duration(days: (365 * 10))),
                  context: context,
                );

                if (newDate != null) {
                  //TODO test what happens if send a null date
                  ref
                      .read(
                        updateProductControllerProvider(
                          searchProductKey,
                        ).notifier,
                      )
                      .updateValues(
                        grDocCode: receiptCode,
                        newValidityDate: newDate,
                        isSubtract: false,
                        quantity: 0,
                        //TODO fix
                        productPackingCode: product.ProductPackingCode!,
                      );
                }
              },
            );
          },
        ),
      ],
    );
  }
}
