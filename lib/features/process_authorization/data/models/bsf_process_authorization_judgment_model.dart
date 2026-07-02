// lib/features/process_authorization/data/models/bsf_authorization_process_judgment_model.dart
import 'package:celta_inventario/core/data/models/enterprise/bsf/bsf.dart';
import 'package:celta_inventario/features/process_authorization/data/models/models.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';

class BSFProcessAuthorizationJudgmentModel
    extends BSFProcessAuthorizationJudgmentEntity {
  const BSFProcessAuthorizationJudgmentModel({
    super.code,
    super.status,
    super.statusString,
    super.observationsVotes,
    super.dateTimeOfCreation,
    super.wasSawByOwner,
    super.authorizationProcessConfigItemType,
    super.user,
    super.enterprise,
    super.authorizationProcessItem,
    super.authorizators,
  });

  factory BSFProcessAuthorizationJudgmentModel.fromJson(Map json) =>
      BSFProcessAuthorizationJudgmentModel(
        code: json['Code'],
        status: BSFProcessAuthorizationJudgementStatus.fromValue(
          json['Status'],
        ),
        statusString: json['StatusString']?.toString(),
        observationsVotes: json['ObservationsVotes']?.toString(),
        dateTimeOfCreation: json['DateTimeOfCreation'] != null
            ? DateTime.parse(json['DateTimeOfCreation'])
            : null,
        wasSawByOwner: json['WasSawByOwner'],
        authorizationProcessConfigItemType:
            json['AuthorizationProcessConfigItemType'],
        user: json['User'] != null ? BSFUserModel.fromJson(json['User']) : null,
        enterprise: json['Enterprise'] != null
            ? BSFEnterpriseModel.fromJson(json['Enterprise'])
            : null,
        authorizationProcessItem: json['AuthorizationProcessItem'] != null
            ? BSFProcessAuthorizationItemModel.fromJson(
                json['AuthorizationProcessItem'],
              )
            : null,
        authorizators: json['Authorizators'] != null
            ? List<BSFUserModel>.from(
                json['Authorizators'].map((x) => BSFUserModel.fromJson(x)),
              )
            : null,
      );

  Map<String, dynamic> toJson() => {
    'Code': code,
    'Status': status?.value,
    'StatusString': statusString,
    'ObservationsVotes': observationsVotes,
    'DateTimeOfCreation': dateTimeOfCreation?.toIso8601String(),
    'WasSawByOwner': wasSawByOwner,
    'AuthorizationProcessConfigItemType': authorizationProcessConfigItemType,
    'User': user != null ? BSFUserModel.fromEntity(user!).toJson() : null,
    'Enterprise': enterprise != null
        ? BSFEnterpriseModel.fromEntity(enterprise!).toJson()
        : null,
    'AuthorizationProcessItem': authorizationProcessItem != null
        ? BSFProcessAuthorizationItemModel.fromEntity(
            authorizationProcessItem!,
          ).toJson()
        : null,
    'Authorizators': authorizators
        ?.map((x) => BSFUserModel.fromEntity(x).toJson())
        .toList(),
  };

  factory BSFProcessAuthorizationJudgmentModel.fromEntity(
    BSFProcessAuthorizationJudgmentEntity entity,
  ) => BSFProcessAuthorizationJudgmentModel(
    code: entity.code,
    status: entity.status,
    statusString: entity.statusString,
    observationsVotes: entity.observationsVotes,
    dateTimeOfCreation: entity.dateTimeOfCreation,
    wasSawByOwner: entity.wasSawByOwner,
    authorizationProcessConfigItemType:
        entity.authorizationProcessConfigItemType,
    user: entity.user,
    enterprise: entity.enterprise,
    authorizationProcessItem: entity.authorizationProcessItem,
    authorizators: entity.authorizators,
  );

  BSFProcessAuthorizationJudgmentEntity toEntity() =>
      BSFProcessAuthorizationJudgmentEntity(
        code: code,
        status: status,
        statusString: statusString,
        observationsVotes: observationsVotes,
        dateTimeOfCreation: dateTimeOfCreation,
        wasSawByOwner: wasSawByOwner,
        authorizationProcessConfigItemType: authorizationProcessConfigItemType,
        user: user,
        enterprise: enterprise,
        authorizationProcessItem: authorizationProcessItem,
        authorizators: authorizators,
      );
}
