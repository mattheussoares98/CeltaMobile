import 'package:flutter/widgets.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../domain/entities/entities.dart';

class Code extends StatelessWidget {
  final BuyQuotationEntity buyQuotation;
  const Code({super.key, required this.buyQuotation});

  @override
  Widget build(BuildContext context) {
    if (buyQuotation.Code == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: TitleAndSubTitle(
        title: 'Código'.hardcoded,
        subTitle: buyQuotation.Code.toString(),
      ),
    );
  }
}
