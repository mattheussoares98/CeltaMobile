import 'package:celta_intelligence/core/domain/entities/address/address_entity.dart';
import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../controllers/controllers.dart';
import '../../components/components.dart';

class InformedAddressess extends ConsumerWidget {
  const InformedAddressess({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addresses = ref.watch(
      customerStateControllerProvider.select((s) => s.value?.Addresses),
    );

    if (addresses == null || addresses.isEmpty == true) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverList.builder(
      itemCount: addresses.length + 1,
      itemBuilder: (_, index) {
        if (index == 0) {
          return const DefaultDivider('Endereços informados');
        }

        final address = addresses[index - 1];

        return _AddressItem(
          key: ValueKey('${address.Zip}${address.Number}'),
          address: address,
          removeAddress: () => ref
              .read(customerStateControllerProvider.notifier)
              .updateAddresses([...addresses]..remove(address)),
        );
      },
    );
  }
}

class _AddressItem extends StatelessWidget {
  final AddressEntity address;
  final VoidCallback removeAddress;

  const _AddressItem({
    super.key,
    required this.address,
    required this.removeAddress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return RepaintBoundary(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TitleAndSubTitle(
                      title: 'CEP '.hardcoded,
                      subTitle: address.Zip,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showAlertDialog(
                        context: context,
                        title: 'Excluir endereço?'.hardcoded,
                        onOkPressed: removeAddress,
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
              Text(
                '${address.Address}, número ${address.Number}. ${address.District}, ${address.City}, ${address.State?.name}',
              ),
              if (address.Complement != null && address.Complement!.isNotEmpty)
                TitleAndSubTitle(
                  title: 'Complemento '.hardcoded,
                  subTitle: address.Complement,
                ),
              if (address.Reference != null && address.Reference!.isNotEmpty)
                TitleAndSubTitle(
                  title: 'Referência '.hardcoded,
                  subTitle: address.Reference,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
