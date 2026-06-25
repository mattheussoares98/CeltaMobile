// lib/features/process_authorization/data/models/bsf_process_authorization_statistic_model.dart
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';

class BsfProcessAuthorizationStatisticModel extends BsfProcessAuthorizationStatisticEntity {
  const BsfProcessAuthorizationStatisticModel({
    required super.allJudgements,
    required super.openedJudgements,
    required super.closedNotAuthorizedJudgements,
    required super.judgementsToVote,
    required super.judgementsCreatedByUser,
    required super.allFinishJudgementThatUserNotSaw,
  });

  factory BsfProcessAuthorizationStatisticModel.fromJson(Map json) =>
      BsfProcessAuthorizationStatisticModel(
        allJudgements: json['AllJudgements'] as int?,
        openedJudgements: json['OpenedJudgements'] as int?,
        closedNotAuthorizedJudgements: json['ClosedNotAuthorizedJudgements'] as int?,
        judgementsToVote: json['JudgementsToVote'] as int?,
        judgementsCreatedByUser: json['JudgementsCreatedByUser'] as int?,
        allFinishJudgementThatUserNotSaw: json['AllFinishJudgementThatUserNotSaw'] as int?,
      );

  Map toJson() => {
        'AllJudgements': allJudgements,
        'OpenedJudgements': openedJudgements,
        'ClosedNotAuthorizedJudgements': closedNotAuthorizedJudgements,
        'JudgementsToVote': judgementsToVote,
        'JudgementsCreatedByUser': judgementsCreatedByUser,
        'AllFinishJudgementThatUserNotSaw': allFinishJudgementThatUserNotSaw,
      };

  factory BsfProcessAuthorizationStatisticModel.fromEntity(
    BsfProcessAuthorizationStatisticEntity entity,
  ) =>
      BsfProcessAuthorizationStatisticModel(
        allJudgements: entity.allJudgements,
        openedJudgements: entity.openedJudgements,
        closedNotAuthorizedJudgements: entity.closedNotAuthorizedJudgements,
        judgementsToVote: entity.judgementsToVote,
        judgementsCreatedByUser: entity.judgementsCreatedByUser,
        allFinishJudgementThatUserNotSaw: entity.allFinishJudgementThatUserNotSaw,
      );

  BsfProcessAuthorizationStatisticEntity toEntity() =>
      BsfProcessAuthorizationStatisticEntity(
        allJudgements: allJudgements,
        openedJudgements: openedJudgements,
        closedNotAuthorizedJudgements: closedNotAuthorizedJudgements,
        judgementsToVote: judgementsToVote,
        judgementsCreatedByUser: judgementsCreatedByUser,
        allFinishJudgementThatUserNotSaw: allFinishJudgementThatUserNotSaw,
      );
}
