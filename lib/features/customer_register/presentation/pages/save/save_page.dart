import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/customer_register/presentation/pages/pages.dart';
import 'package:celta_inventario/features/customer_register/presentation/pages/save/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

class SavePage extends StatelessWidget {
  const SavePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScrollableWidget(
      isSliverPage: true,
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: BaseText.headline(
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
    );
  }
}
