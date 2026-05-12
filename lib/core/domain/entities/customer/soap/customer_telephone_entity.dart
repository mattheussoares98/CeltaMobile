import 'package:equatable/equatable.dart';

class CustomerTelephoneEntity extends Equatable {
  final String? AreaCode;
  final String? PhoneNumber;

  const CustomerTelephoneEntity({
    required this.AreaCode,
    required this.PhoneNumber,
  });

  @override
  List<Object?> get props => [AreaCode, PhoneNumber];
}
