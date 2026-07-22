import 'package:celta_inventario/features/process_authorization/data/models/models.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';

class BSFProcessAuthorizationJudgmentVoteModel
    extends BSFProcessAuthorizationJudgmentVoteEntity {
  const BSFProcessAuthorizationJudgmentVoteModel({
    super.voteType,
    super.dateTimeOfCreation,
    super.user,
    super.observations,
  });

  factory BSFProcessAuthorizationJudgmentVoteModel.fromJson(Map json) =>
      BSFProcessAuthorizationJudgmentVoteModel(
        voteType: json['VoteType'],
        dateTimeOfCreation: json['DateTimeOfCreation'] != null
            ? DateTime.parse(json['DateTimeOfCreation'].toString())
            : null,
        user: json['User'] != null
            ? BSFUserModel.fromJson(json['User'] as Map)
            : null,
        observations: json['Observations']?.toString(),
      );

  Map toJson() => {
    'VoteType': voteType,
    'DateTimeOfCreation': dateTimeOfCreation?.toIso8601String(),
    'User': user != null ? BSFUserModel.fromEntity(user!).toJson() : null,
    'Observations': observations,
  };

  factory BSFProcessAuthorizationJudgmentVoteModel.fromEntity(
    BSFProcessAuthorizationJudgmentVoteEntity entity,
  ) => BSFProcessAuthorizationJudgmentVoteModel(
    voteType: entity.voteType,
    dateTimeOfCreation: entity.dateTimeOfCreation,
    user: entity.user,
    observations: entity.observations,
  );

  BSFProcessAuthorizationJudgmentVoteEntity toEntity() =>
      BSFProcessAuthorizationJudgmentVoteEntity(
        voteType: voteType,
        dateTimeOfCreation: dateTimeOfCreation,
        user: user,
        observations: observations,
      );
}
