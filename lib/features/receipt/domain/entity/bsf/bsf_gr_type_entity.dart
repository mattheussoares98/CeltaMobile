import 'package:equatable/equatable.dart';

class BSFGRTypeEntity extends Equatable {
  final int? code;
  final String? name;

  const BSFGRTypeEntity({this.code, this.name});

  @override
  List<Object?> get props => [code, name];
}
