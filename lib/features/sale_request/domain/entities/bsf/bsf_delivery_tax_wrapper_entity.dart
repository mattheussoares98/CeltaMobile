import 'package:equatable/equatable.dart';

import 'bsf.dart';

class BSFDeliveryTaxWrapperEntity extends Equatable {
  final BSFValueTypeEntity? deliveryTax;
  final dynamic mailFreightType;
  final bool? isFob;
  final bool? isDiscounted;

  const BSFDeliveryTaxWrapperEntity({
    required this.deliveryTax,
    required this.mailFreightType,
    required this.isFob,
    required this.isDiscounted,
  });

  @override
  List<Object?> get props => [deliveryTax, mailFreightType, isFob, isDiscounted];
}
