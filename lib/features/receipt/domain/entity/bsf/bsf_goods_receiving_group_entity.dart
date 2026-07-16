import 'package:equatable/equatable.dart';

class BSFGoodsReceivingGroupEntity extends Equatable {
  final int? code;
  final String personalizedCode;

  const BSFGoodsReceivingGroupEntity({
    required this.code,
    required this.personalizedCode,
  });

  @override
  List<Object?> get props => [code, personalizedCode];
}
