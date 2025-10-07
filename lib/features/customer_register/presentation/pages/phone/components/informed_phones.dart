import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../phone.dart';

class InformedPhones extends StatelessWidget {
  const InformedPhones(this.page, {super.key});

  final PhonePage page;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: page.phones.length,
      itemBuilder: (_, index) {
        final phone = page.phones[index];

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
                        page.removePhone(index);
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
    );
  }
}
