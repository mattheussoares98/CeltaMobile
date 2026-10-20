import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/customer_register/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/customer_register/presentation/pages/components/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      ref
          .read(customerStateControllerProvider.notifier)
          .updateEmails([...emails]..removeAt(index));
    }

    return SliverList.builder(
      itemCount: emails.length + 1,
      itemBuilder: (_, index) {
        if (index == 0) {
          return DefaultDivider(context.l10n.enteredEmails);
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: Sizes.p8),
        child: Row(
          children: [
            Expanded(child: BaseText(email)),
            IconButton(
              onPressed: () async {
                final confirmed = await showAlertDialog(
                  context: context,
                  title: context.l10n.removeEmail,
                  defaultActionText: context.l10n.yes,
                  cancelActionText: context.l10n.no,
                );

                if (confirmed != true || !context.mounted) return;
                removeEmail();
              },
              icon: const PlatformIcon(
                cupertinoIcon: CupertinoIcons.delete,
                materialIcon: Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
