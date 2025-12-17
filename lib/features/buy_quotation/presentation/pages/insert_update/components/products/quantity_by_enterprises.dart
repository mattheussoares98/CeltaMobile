import 'package:flutter/material.dart';

import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../domain/entities/entities.dart';

class QuantityByEnterprises extends StatelessWidget {
  final List<BuyQuotationProductEnterpriseEntity>? productEnterprises;
  final List<EnterpriseEntity>? enterprises;
  const QuantityByEnterprises({
    super.key,
    required this.productEnterprises,
    required this.enterprises,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        ...?productEnterprises?.map((e) {
          final correspondentEnterprise = enterprises?.firstWhere(
            (x) => e.EnterpriseCode == x.Code,
          );
          return Row(
            children: [
              Expanded(
                child: Text(
                  "(${correspondentEnterprise?.PersonalizedCode}) - ${correspondentEnterprise?.name}",
                  style: theme.textTheme.titleSmall,
                ),
              ),
              Text((e.Quantity ?? 0).toString().toBrazilianNumber()),
            ],
          );
        }),
      ],
    );
  }
}
