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
  const InformedPhones({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final telephones = ref.watch(
      customerStateControllerProvider.select((s) => s.value?.Telephones),
    );

    if (telephones == null || telephones.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    void removeTelephone(int index) {
      ref
          .read(customerStateControllerProvider.notifier)
          .updateTelephones([...telephones]..removeAt(index));
    }

    return SliverList.builder(
      itemCount: telephones.length + 1,
      itemBuilder: (_, index) {
        if (index == 0) {
          return DefaultDivider('Telefones informados'.hardcoded);
        }
        final telephone = telephones[index - 1];

        return _TelephoneItem(
          key: ValueKey('${telephone.AreaCode}${telephone.PhoneNumber}'),
          removeTelephone: () => removeTelephone(index - 1),
          telephone: telephone,
        );
      },
    );
  }
}

class _TelephoneItem extends StatelessWidget {
  final VoidCallback removeTelephone;
  final CustomerTelephoneEntity telephone;
  const _TelephoneItem({
    super.key,
    required this.removeTelephone,
    required this.telephone,
  });

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
              Expanded(
                child: Text('(${telephone.AreaCode}) ${telephone.PhoneNumber}'),
              ),
              IconButton(
                onPressed: () {
                  showAlertDialog(
                    context: context,
                    title: 'Remover telefone?'.hardcoded,
                    defaultActionText: 'Sim'.hardcoded,
                    cancelActionText: 'Cancelar'.hardcoded,
                    onOkPressed: removeTelephone,
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
