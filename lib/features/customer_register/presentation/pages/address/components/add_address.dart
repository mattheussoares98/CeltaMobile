import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/widgets/address/address.dart';
import 'package:celta_inventario/features/customer_register/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddAddress extends ConsumerWidget {
  const AddAddress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<bool> addAddress(AddressEntity newAddress) async {
      final customer = await ref.read(customerStateControllerProvider.future);
      final addresses = customer?.Addresses;

      if (addresses?.any(
            (e) => e.Zip == newAddress.Zip && e.Number == newAddress.Number,
          ) ??
          false) {
        showSnackBarMessage(
          null,
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
