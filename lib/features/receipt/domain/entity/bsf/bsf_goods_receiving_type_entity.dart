import 'package:equatable/equatable.dart';

class BSFGoodsReceivingTypeEntity extends Equatable {
  final int? code;
  final String? name;

  const BSFGoodsReceivingTypeEntity({this.code, this.name});

  @override
  List<Object?> get props => [code, name];
}
