import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import '../../components/components.dart';

class BindedCovenants extends ConsumerWidget {
  const BindedCovenants({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final covenants = ref.watch(
      customerStateControllerProvider.select((s) => s.value?.CustomerCovenants),
    );
    if (covenants == null || covenants.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverList.builder(
      itemCount: covenants.length + 1,
      itemBuilder: (_, index) {
        if (index == 0) {
          return DefaultDivider('Convênios vinculados'.hardcoded);
        }

        final covenant = covenants[index - 1];

        return _CovenantItem(
          key: ValueKey('${covenant.covenant?.Code}'),
          covenant: covenant,
          removeCovenant: () {
            ref
                .read(customerStateControllerProvider.notifier)
                .updateCustomerCovenants([...covenants..removeAt(index - 1)]);
          },
        );
      },
    );
  }
}

class _CovenantItem extends ConsumerWidget {
  final CustomerCovenantEntity covenant;
  final VoidCallback removeCovenant;
  const _CovenantItem({
    super.key,
    required this.covenant,
    required this.removeCovenant,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return RepaintBoundary(
      child: Card(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(Sizes.p8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    covenant.covenant?.Name ?? '',
                    style: theme.textTheme.titleMedium,
                  ),
                  TitleAndSubTitle(
                    title: 'Código '.hardcoded,
                    subTitle: covenant.covenant?.Code.toString(),
                  ),
                  TitleAndSubTitle(
                    title: 'Limite '.hardcoded,
                    subTitle:
                        'R\$ ${covenant.LimitOfPurchase.toString().toBrazilianNumber(2, false)}',
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                onPressed: () {
                  showAlertDialog(
                    context: context,
                    title: 'Remover convênio'.hardcoded,
                    content: 'Tem certeza que deseja remover esse convênio?'
                        .hardcoded,
                    onOkPressed: removeCovenant,
                    cancelActionText: 'Não'.hardcoded,
                    defaultActionText: 'Sim'.hardcoded,
                  );
                },
                icon: Icon(
                  isIOS ? CupertinoIcons.delete : Icons.delete,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
