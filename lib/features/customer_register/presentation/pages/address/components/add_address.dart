import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/widgets/address/address.dart';
import 'package:celta_inventario/features/customer_register/presentation/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddAddress extends ConsumerWidget {
  const AddAddress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<bool> addAddress(AddressEntity newAddress) async {
      final customer = await ref.read(customerStateControllerProvider.future);
      if (!context.mounted) return false;
      final addresses = customer?.Addresses;

      if (addresses?.any(
            (e) => e.Zip == newAddress.Zip && e.Number == newAddress.Number,
          ) ??
          false) {
        showToastMessage(
          context.l10n.thisAddressHasAlreadyBeenAdded,
          type: ToastType.error,
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
