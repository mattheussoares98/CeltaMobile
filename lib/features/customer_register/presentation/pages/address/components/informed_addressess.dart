import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import '../../components/components.dart';
import '../address.dart';

class InformedAddressess extends ConsumerWidget {
  final AddressPage page;
  final CustomerEntity? customer;
  const InformedAddressess(this.page, this.customer, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return Column(
      children: [
        DefaultDivider('Endereços informados'),
        ListView.builder(
          shrinkWrap: true,
          itemCount: customer?.Addresses?.length,
          itemBuilder: (_, index) {
            final address = customer!.Addresses![index];
            return Card(
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
                              onOkPressed: () {
                                ref
                                    .read(
                                      customerStateControllerProvider.notifier,
                                    )
                                    .updateCustomer(
                                      customer!.copyWith(
                                        Addresses: [...?customer!.Addresses]
                                          ..remove(address),
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
                    Text(
                      '${address.Address}, número ${address.Number}. ${address.District}, ${address.City}, ${address.State?.name}',
                    ),
                    if (address.Complement != null &&
                        address.Complement!.isNotEmpty)
                      TitleAndSubTitle(
                        title: 'Complemento '.hardcoded,
                        subTitle: address.Complement,
                      ),
                    if (address.Reference != null &&
                        address.Reference!.isNotEmpty)
                      TitleAndSubTitle(
                        title: 'Referência '.hardcoded,
                        subTitle: address.Reference,
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
