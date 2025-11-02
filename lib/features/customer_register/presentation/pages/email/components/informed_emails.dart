import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../controllers/controllers.dart';
import '../../components/components.dart';

class InformedEmails extends ConsumerWidget {
  const InformedEmails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customer = ref.watch(customerStateControllerProvider).value;

    if (customer?.Emails == null || customer!.Emails!.isEmpty) {
      return const SizedBox.shrink();
    }

    void removeEmail(int index) {
      ref
          .read(customerStateControllerProvider.notifier)
          .updateCustomer(
            customer.copyWith(Emails: [...customer.Emails!..removeAt(index)]),
          );
    }

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    return Column(
      children: [
        DefaultDivider('E-mails informados'.hardcoded),
        ListView.builder(
          shrinkWrap: true,
          itemCount: customer.Emails!.length,
          itemBuilder: (_, index) {
            final email = customer.Emails![index];

            return Card(
              child: Padding(
                padding: const EdgeInsets.only(left: Sizes.p8),
                child: Row(
                  children: [
                    Expanded(child: Text(email)),
                    IconButton(
                      onPressed: () {
                        showAlertDialog(
                          context: context,
                          title: 'Remover e-mail?'.hardcoded,
                          onOkPressed: () => removeEmail(index),
                          defaultActionText: 'Sim'.hardcoded,
                          cancelActionText: 'Não'.hardcoded,
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
