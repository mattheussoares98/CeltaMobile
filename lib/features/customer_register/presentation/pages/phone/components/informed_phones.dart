import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import '../../components/components.dart';

class InformedPhones extends ConsumerWidget {
  final CustomerEntity? customer;
  const InformedPhones({super.key, required this.customer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void removeTelephone(int index) {
      ref
          .read(customerStateControllerProvider.notifier)
          .updateCustomer(
            customer!.copyWith(
              Telephones: [...customer!.Telephones!..removeAt(index)],
            ),
          );
    }

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return Column(
      children: [
        DefaultDivider('Telefones informados'.hardcoded),
        ListView.builder(
          shrinkWrap: true,
          itemCount: customer?.Telephones?.length,
          itemBuilder: (_, index) {
            final phone = customer!.Telephones![index];

            return Card(
              child: Padding(
                padding: EdgeInsets.only(left: Sizes.p8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('(${phone.AreaCode}) ${phone.PhoneNumber}'),
                    ),
                    IconButton(
                      onPressed: () {
                        showAlertDialog(
                          context: context,
                          title: 'Remover telefone?'.hardcoded,
                          defaultActionText: 'Sim'.hardcoded,
                          cancelActionText: 'Cancelar'.hardcoded,
                          onOkPressed: () {
                            removeTelephone(index);
                          },
                        );
                      },
                      icon: Icon(
                        isIOS ? CupertinoIcons.delete : Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
