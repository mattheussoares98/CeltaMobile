import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../pages.dart';
import 'components/components.dart';

class SavePage extends StatelessWidget {
  final CustomerEntity? customer;
  final TextEditingController passwordController;
  final AddressPage addressPage;
  const SavePage({
    super.key,
    required this.customer,
    required this.passwordController,
    required this.addressPage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Salvar'.hardcoded)),
      body: ResponsiveScrollableWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DefaultTitle(title: 'Dados pessoais'.hardcoded),
            PersonalDataInformations(
              customer: customer,
              passwordController: passwordController,
            ),
            if (customer?.Addresses != null && customer!.Addresses!.isNotEmpty)
              InformedAddressess(addressPage, customer),
            if (customer?.Emails != null && customer!.Emails!.isNotEmpty)
              InformedEmails(customer: customer),
            if (customer?.Telephones != null &&
                customer!.Telephones!.isNotEmpty)
              InformedPhones(customer: customer),
            if (customer?.CustomerCovenants != null &&
                customer!.CustomerCovenants!.isNotEmpty)
              BindedCovenants(customer: customer, changeSelectedIndex: null),
          ],
        ),
      ),
    );
  }
}
