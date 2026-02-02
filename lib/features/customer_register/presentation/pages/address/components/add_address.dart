import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/widgets/address/address.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';

class AddAddress extends ConsumerWidget {
  const AddAddress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<bool> addAddress(AddressEntity newAddress) async {
      final addresses = await ref.read(
        customerStateControllerProvider.selectAsync((s) => s?.Addresses),
      );

      if (addresses?.any(
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

      ref.read(customerStateControllerProvider.notifier).updateAddresses([
        ...?addresses,
        newAddress,
      ]);

      return true;
    }

    return AddressForm(
      module: Modules.customerRegister,
      addAddress: addAddress,
    );
  }
}
