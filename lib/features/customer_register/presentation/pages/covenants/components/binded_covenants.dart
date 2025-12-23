import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../controllers/controllers.dart';
import '../../components/components.dart';

class BindedCovenants extends ConsumerWidget {
  const BindedCovenants({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customer = ref.watch(customerStateControllerProvider).value;
    if (customer?.CustomerCovenants == null ||
        customer!.CustomerCovenants!.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return SliverList.builder(
      itemCount: customer.CustomerCovenants!.length + 1,
      itemBuilder: (_, index) {
        if (index == 0) {
          return DefaultDivider('Convênios vinculados'.hardcoded);
        }

        final covenant = customer.CustomerCovenants![index - 1];
        return Card(
          child: Padding(
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
                Row(
                  children: [
                    Expanded(
                      child: TitleAndSubTitle(
                        title: 'Limite '.hardcoded,
                        subTitle:
                            'R\$ ${covenant.LimitOfPurchase.toString().toBrazilianNumber(2, false)}',
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showAlertDialog(
                          context: context,
                          title: 'Remover convênio'.hardcoded,
                          content:
                              'Tem certeza que deseja remover esse convênio?'
                                  .hardcoded,
                          onOkPressed: () {
                            ref
                                .read(customerStateControllerProvider.notifier)
                                .updateCustomer(
                                  customer.copyWith(
                                    CustomerCovenants: [
                                      ...customer.CustomerCovenants!
                                        ..removeAt(index),
                                    ],
                                  ),
                                );
                          },
                          cancelActionText: 'Não'.hardcoded,
                          defaultActionText: 'Sim'.hardcoded,
                        );
                      },
                      icon: Icon(
                        isIOS ? CupertinoIcons.delete : Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
