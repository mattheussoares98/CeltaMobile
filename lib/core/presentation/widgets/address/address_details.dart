import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';

class AddressDetails extends StatelessWidget {
  final AddressEntity? address;
  const AddressDetails({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    if (address?.Address == null || address!.Address.isEmpty) {
      return const SizedBox.shrink();
    }

    final addressDetails = StringBuffer();
    addressDetails.write(address!.Address);
    addressDetails.write(', ');
    addressDetails.write(address!.District);
    addressDetails.write(', ');
    addressDetails.write(address!.City);
    addressDetails.write(', ');
    addressDetails.write(address!.Number);
    addressDetails.write(', ');
    addressDetails.write(address!.State?.name);
    addressDetails.write('. ${context.l10n.postalCode} ');
    addressDetails.write(address!.Zip);
    if (address?.Complement != null && address!.Complement!.isNotEmpty) {
      addressDetails.write('. ');
      addressDetails.write(address!.Complement);
    }
    if (address?.Reference != null && address!.Reference!.isNotEmpty) {
      addressDetails.write(', ');
      addressDetails.write(address!.Reference);
    }

    return TitleAndSubTitle(
      title: context.l10n.address,
      subTitle: addressDetails,
    );
  }
}
