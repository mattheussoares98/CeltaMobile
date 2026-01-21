import 'package:celta_inventario/localization/string_hardcoded.dart';
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
    final emails = ref.watch(
      customerStateControllerProvider.select((s) => s.value?.Emails),
    );

    if (emails == null || emails.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    void removeEmail(int index) {
      ref.read(customerStateControllerProvider.notifier).updateEmails([
        ...emails..removeAt(index),
      ]);
    }

    return SliverList.builder(
      itemCount: emails.length + 1,
      itemBuilder: (_, index) {
        if (index == 0) {
          return DefaultDivider('E-mails informados'.hardcoded);
        }
        final email = emails[index - 1];

        return _EmailItem(
          key: ValueKey(email),
          email: email,
          removeEmail: () => removeEmail(index - 1),
        );
      },
    );
  }
}

class _EmailItem extends StatelessWidget {
  final String email;
  final VoidCallback removeEmail;
  const _EmailItem({super.key, required this.email, required this.removeEmail});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return RepaintBoundary(
      child: Card(
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
                    onOkPressed: removeEmail,
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
      ),
    );
  }
}
