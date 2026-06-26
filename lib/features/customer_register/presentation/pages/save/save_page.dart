import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/customer_register/presentation/pages/pages.dart';
import 'package:celta_inventario/features/customer_register/presentation/pages/save/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

class SavePage extends StatelessWidget {
  const SavePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      isScrollable: false,
      usePadding: true,
      appBar: DefaultAppBar(
        title: 'Salvar'.hardcoded,
        showSelectedEnterprise: false,
        actions: const [SaveButton()],
      ),
      body: ResponsiveScrollableWidget(
        isSliverPage: true,
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: DefaultText.headline(
                'Dados pessoais'.hardcoded,
                textAlign: TextAlign.center,
              ),
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
