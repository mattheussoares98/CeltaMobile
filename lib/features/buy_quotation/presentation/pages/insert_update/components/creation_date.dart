import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../domain/entities/entities.dart';

class CreationDate extends StatelessWidget {
  final BuyQuotationEntity buyQuotation;
  const CreationDate({super.key, required this.buyQuotation});

  @override
  Widget build(BuildContext context) {
    if (buyQuotation.DateOfCreation != null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: TitleAndSubTitle(
        title: 'Data de criação'.hardcoded,
        subTitle: DateFormat(
          'dd/MM/yyyy HH:mm',
        ).format(buyQuotation.DateOfCreation!),
      ),
    );
  }
}
