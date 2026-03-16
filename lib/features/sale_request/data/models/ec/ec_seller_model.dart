import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class EcSellerModel extends Equatable {
  final int Id;
  final String Name;

  const EcSellerModel({required this.Id, required this.Name});

  @override
  List<Object?> get props => [Id, Name];

  factory EcSellerModel.fromJson(Map json) =>
      EcSellerModel(Id: json['Id'], Name: json['Name']);

  Map<String, dynamic> toJson() => {'Id': Id, 'Name': Name};

  factory EcSellerModel.fromEntity(SellerEntity entity) =>
      EcSellerModel(Id: entity.Id, Name: entity.Name);

  SellerEntity toEntity() => SellerEntity(Id: Id, Name: Name);
}
