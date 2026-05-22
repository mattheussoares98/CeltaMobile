import 'package:equatable/equatable.dart';

import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';

class EcSellerModel extends Equatable {
  final int Id;
  final String Name;

  const EcSellerModel({required this.Id, required this.Name});

  @override
  List<Object?> get props => [Id, Name];

  factory EcSellerModel.fromJson(Map json) =>
      EcSellerModel(Id: json['id'], Name: json['name']);

  Map<String, dynamic> toJson() => {'id': Id, 'name': Name};

  factory EcSellerModel.fromEntity(SellerEntity entity) =>
      EcSellerModel(Id: entity.Id, Name: entity.Name);

  SellerEntity toEntity() => SellerEntity(Id: Id, Name: Name);
}
