import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnterpriseItems extends ConsumerWidget {
  final List<EnterpriseEntity> enterprises;
  final void Function(EnterpriseEntity enterprise) onTap;
  final VoidCallback onRefresh;
  const EnterpriseItems({
    super.key,
    required this.enterprises,
    required this.onTap,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveListFlow(
      itemCount: enterprises.length,
      itemBuilder: (_, index) {
        final enterprise = enterprises[index];
        return _EnterpriseItem(
          key: ValueKey(enterprise.id),
          enterprise: enterprise,
          onTap: () => onTap(enterprise),
        );
      },
    );
  }
}

class _EnterpriseItem extends StatelessWidget {
  final EnterpriseEntity enterprise;
  final VoidCallback onTap;
  const _EnterpriseItem({
    super.key,
    required this.enterprise,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleAndSubTitle(
                title: null,
                subTitle: '${enterprise.PersonalizedCode} - ${enterprise.name}',
              ),
              TitleAndSubTitle(
                title: 'CNPJ'.hardcoded,
                subTitle: enterprise.CnpjNumber,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
