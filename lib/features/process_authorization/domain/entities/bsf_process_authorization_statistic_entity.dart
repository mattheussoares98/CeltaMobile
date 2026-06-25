// lib/features/process_authorization/domain/entities/bsf_process_authorization_statistic_entity.dart
import 'package:equatable/equatable.dart';

class BsfProcessAuthorizationStatisticEntity extends Equatable {
  final int? allJudgements;
  final int? openedJudgements;
  final int? closedNotAuthorizedJudgements;
  final int? judgementsToVote;
  final int? judgementsCreatedByUser;
  final int? allFinishJudgementThatUserNotSaw;

  const BsfProcessAuthorizationStatisticEntity({
    required this.allJudgements,
    required this.openedJudgements,
    required this.closedNotAuthorizedJudgements,
    required this.judgementsToVote,
    required this.judgementsCreatedByUser,
    required this.allFinishJudgementThatUserNotSaw,
  });

  @override
  List<Object?> get props => [
        allJudgements,
        openedJudgements,
        closedNotAuthorizedJudgements,
        judgementsToVote,
        judgementsCreatedByUser,
        allFinishJudgementThatUserNotSaw,
      ];

  BsfProcessAuthorizationStatisticEntity copyWith({
    int? allJudgements,
    int? openedJudgements,
    int? closedNotAuthorizedJudgements,
    int? judgementsToVote,
    int? judgementsCreatedByUser,
    int? allFinishJudgementThatUserNotSaw,
  }) {
    return BsfProcessAuthorizationStatisticEntity(
      allJudgements: allJudgements ?? this.allJudgements,
      openedJudgements: openedJudgements ?? this.openedJudgements,
      closedNotAuthorizedJudgements:
          closedNotAuthorizedJudgements ?? this.closedNotAuthorizedJudgements,
      judgementsToVote: judgementsToVote ?? this.judgementsToVote,
      judgementsCreatedByUser:
          judgementsCreatedByUser ?? this.judgementsCreatedByUser,
      allFinishJudgementThatUserNotSaw:
          allFinishJudgementThatUserNotSaw ?? this.allFinishJudgementThatUserNotSaw,
    );
  }
}
