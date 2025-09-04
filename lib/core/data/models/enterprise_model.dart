import '../../domain/entities/entities.dart';
import 'models.dart';

class EnterpriseModel {
  final String id;
  final String name;
  final List<SubEnterpriseModel>? subEnterprises;

  const EnterpriseModel({
    required this.id,
    required this.name,
    required this.subEnterprises,
  });

  factory EnterpriseModel.fromJson(Map<String, dynamic> map) {
    return EnterpriseModel(
      id: map['id'] as String,
      name: map['name'] as String,
      subEnterprises: map['subEnterprises'] != null
          ? List<SubEnterpriseModel>.from(
              (map['subEnterprises'] as List<Map<String, dynamic>>)
                  .map<SubEnterpriseModel?>(
                    (x) => SubEnterpriseModel.fromJson(x),
                  ),
            )
          : null,
    );
  }

  EnterpriseEntity toEntity() => EnterpriseEntity(
    id: id,
    name: name,
    subEnterprises: subEnterprises?.map((e) => e.toEntity()).toList(),
  );
}
