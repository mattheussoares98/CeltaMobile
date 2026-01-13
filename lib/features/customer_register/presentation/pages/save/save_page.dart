import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../controllers/controllers.dart';
import '../pages.dart';
import 'components/components.dart';

class SavePage extends ConsumerWidget {
  const SavePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return Scaffold(
      appBar: AppBar(
        title: Text('Salvar'.hardcoded),
        actions: [
          IconButton(
            onPressed: () async {
              showAlertDialog(
                context: context,
                title: 'Salvar dados?'.hardcoded,
                onOkPressed: () {
                  ref
                      .read(insertUpdateCustomerControllerProvider.notifier)
                      .insertUpdate();
                },
                cancelActionText: 'Cancelar'.hardcoded,
                defaultActionText: 'Salvar'.hardcoded,
              );
            },
            icon: Icon(isIOS ? CupertinoIcons.checkmark : Icons.save),
          ),
        ],
      ),
      body: ResponsiveScrollableWidget(
        isSliverPage: true,
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: DefaultTitle(title: 'Dados pessoais'.hardcoded),
            ),
            const SliverToBoxAdapter(child: PersonalDataInformations()),
            const InformedAddressess(),
            const InformedEmails(),
            const InformedPhones(),
            const BindedCovenants(),
          ],
        ),
      ),
    );
  }
}
