import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/widgets/address/address.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class AddressPage extends ConsumerStatefulWidget {
  const AddressPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddressPageState();
}

class _AddressPageState extends ConsumerState<AddressPage> {
  Future<bool> addAddress(AddressEntity newAddress) async {
    final customer = await ref.read(customerStateControllerProvider.future);

    if (customer?.Addresses?.any(
          (e) => e.Zip == newAddress.Zip && e.Number == newAddress.Number,
        ) ??
        false) {
      showSnackBarMessage(
        context,
        'Esse endereço já foi inserido'.hardcoded,
        backgroundColor: Colors.red,
      );

      return false;
    }

    ref
        .read(customerStateControllerProvider.notifier)
        .updateCustomer(
          customer?.copyWith(Addresses: [...?customer.Addresses, newAddress]),
        );

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Endereços'.hardcoded)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
        child: ResponsiveScrollableWidget(
          isSliverPage: true,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: AddressForm(
                  module: Modules.customerRegister,
                  addAddress: addAddress,
                ),
              ),
              const InformedAddressess(),
            ],
          ),
        ),
      ),
    );
  }
}
