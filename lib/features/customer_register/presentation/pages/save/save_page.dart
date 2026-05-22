import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/customer_register/presentation/pages/pages.dart';
import 'package:celta_inventario/features/customer_register/presentation/pages/save/components/components.dart';

class SavePage extends StatelessWidget {
  const SavePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salvar'.hardcoded),
        actions: const [SaveButton()],
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
