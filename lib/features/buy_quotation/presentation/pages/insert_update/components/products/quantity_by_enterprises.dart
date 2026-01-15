import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../utils/utils.dart';
import '../../../../../../enterprises/presentation/controllers/controllers.dart';
import '../../../../../domain/entities/entities.dart';

class QuantityByEnterprises extends ConsumerWidget {
  final List<BuyQuotationProductEnterpriseEntity>? productEnterprises;

  const QuantityByEnterprises({super.key, required this.productEnterprises});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterprises = ref.watch(enterprisesStateControllerProvider()).value;

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
              Text((e.Quantity ?? 0).toString().toBrazilianNumber(3, true)),
            ],
          );
        }),
      ],
    );
  }
}
