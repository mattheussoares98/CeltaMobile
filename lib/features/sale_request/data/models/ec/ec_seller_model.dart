import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class EcSellerModel extends Equatable {
  final int Id;
  final String Name;

  const EcSellerModel({required this.Id, required this.Name});

  @override
  List<Object?> get props => [Id, Name];

  factory EcSellerModel.fromJson(Map json) =>
      EcSellerModel(Id: json['id'], Name: json['name']);

  Map<String, dynamic> toJson() => {'id': Id, 'name': Name};

  factory EcSellerModel.fromEntity(EcSellerEntity entity) =>
      EcSellerModel(Id: entity.Id, Name: entity.Name);

  EcSellerEntity toEntity() => EcSellerEntity(Id: Id, Name: Name);
}
