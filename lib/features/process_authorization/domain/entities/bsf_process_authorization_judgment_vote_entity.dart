import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class BSFProcessAuthorizationJudgmentVoteEntity extends Equatable {
  final int? voteType;
  final DateTime? dateTimeOfCreation;
  final BSFUserEntity? user;
  final String? observations;

  const BSFProcessAuthorizationJudgmentVoteEntity({
    this.voteType,
    this.dateTimeOfCreation,
    this.user,
    this.observations,
  });

  @override
  List<Object?> get props => [voteType, dateTimeOfCreation, user, observations];
}
