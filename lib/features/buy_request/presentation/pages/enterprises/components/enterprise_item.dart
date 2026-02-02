import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../controllers/controllers.dart';

class EnterpriseItem extends ConsumerWidget {
  final EnterpriseEntity enterprise;
  final VoidCallback? onTap;
  final int enterpriseCode;
  const EnterpriseItem({
    super.key,
    required this.enterprise,
    required this.onTap,
    required this.enterpriseCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterpriseIsSelected = ref.watch(
      pendingBuyRequestStateControllerProvider(enterpriseCode).select(
        (s) =>
            s.value?.selectedEnterprises?.any(
              (x) => x.Code == enterprise.Code,
            ) ??
            false,
      ),
    );

    return RepaintBoundary(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleAndSubTitle(
                        title: null,
                        subTitle:
                            '${enterprise.PersonalizedCode} - ${enterprise.name}',
                      ),
                      TitleAndSubTitle(
                        title: 'Nome fantasia'.hardcoded,
                        subTitle: enterprise.FantasizesName,
                      ),
                      TitleAndSubTitle(
                        title: 'CNPJ'.hardcoded,
                        subTitle: enterprise.CnpjNumber,
                      ),
                    ],
                  ),
                ),
                if (onTap != null)
                  Checkbox(
                    value: enterpriseIsSelected,
                    onChanged: (_) => onTap!(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
