import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../address.dart';

class InformedAddressess extends StatelessWidget {
  final AddressPage page;
  const InformedAddressess(this.page, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return Column(
      children: [
        gapH16,
        Divider(thickness: 0.5),
        Text(
          'Endereços informados'.hardcoded,
          style: theme.textTheme.titleLarge,
        ),
        gapH8,
        ListView.builder(
          shrinkWrap: true,
          itemCount: page.addressess.length,
          itemBuilder: (_, index) {
            final address = page.addressess[index];
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
                                page.removeAddress(index);
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
                      '${address.Address}, número ${address.Number}. ${address.District}, ${address.City}, ${address.State}',
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
