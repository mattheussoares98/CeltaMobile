import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/customer_register/presentation/pages/address/components/components.dart';

class AddressPage extends ConsumerWidget {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Endereços'.hardcoded)),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes.p4),
        child: ResponsiveScrollableWidget(
          isSliverPage: true,
          child: Column(
            children: [
              AddAddress(),
              Expanded(
                child: CustomScrollView(
                  physics: ClampingScrollPhysics(),
                  slivers: [InformedAddressess()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
