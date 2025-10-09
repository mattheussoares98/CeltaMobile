import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../controllers/controllers.dart';

class BindedCovenants extends ConsumerWidget {
  final List<CustomerCovenantEntity> bindedCovenants;
  final CustomerEntity? customer;
  const BindedCovenants({
    super.key,
    required this.bindedCovenants,
    required this.customer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: bindedCovenants.length,
      itemBuilder: (_, index) {
        final covenant = bindedCovenants[index];
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
                                  customer!.copyWith(
                                    CustomerCovenants: [
                                      ...bindedCovenants..removeAt(index),
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
