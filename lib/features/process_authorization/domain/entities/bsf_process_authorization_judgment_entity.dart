import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class BSFProcessAuthorizationJudgmentEntity extends Equatable {
  final int? code;
  final BSFProcessAuthorizationJudgementStatus? status;
  final String? statusString;
  final String? observationsVotes;
  final DateTime? dateTimeOfCreation;
  final bool? wasSawByOwner;
  final int? authorizationProcessConfigItemType;
  final BSFUserEntity? user;
  final BSFEnterpriseEntity? enterprise;
  final BSFProcessAuthorizationItemEntity? authorizationProcessItem;
  final List<BSFUserEntity>? authorizators;
  final List<BSFDefendantEntity>? defendants;
  final List<BSFProcessAuthorizationJudgmentVoteEntity>? votes;

  const BSFProcessAuthorizationJudgmentEntity({
    this.code,
    this.status,
    this.statusString,
    this.observationsVotes,
    this.dateTimeOfCreation,
    this.wasSawByOwner,
    this.authorizationProcessConfigItemType,
    this.user,
    this.enterprise,
    this.authorizationProcessItem,
    this.authorizators,
    this.defendants,
    this.votes,
  });

  @override
  List<Object?> get props => [
    code,
    status,
    statusString,
    observationsVotes,
    dateTimeOfCreation,
    wasSawByOwner,
    authorizationProcessConfigItemType,
    user,
    enterprise,
    authorizationProcessItem,
    authorizators,
    defendants,
    votes,
  ];

  BSFProcessAuthorizationJudgmentEntity copyWith({
    int? code,
    BSFProcessAuthorizationJudgementStatus? status,
    String? statusString,
    String? observationsVotes,
    DateTime? dateTimeOfCreation,
    bool? wasSawByOwner,
    int? authorizationProcessConfigItemType,
    BSFUserEntity? user,
    BSFEnterpriseEntity? enterprise,
    BSFProcessAuthorizationItemEntity? authorizationProcessItem,
    List<BSFUserEntity>? authorizators,
    List<BSFDefendantEntity>? defendants,
    List<BSFProcessAuthorizationJudgmentVoteEntity>? votes,
    bool? annulDefendants,
  }) {
    return BSFProcessAuthorizationJudgmentEntity(
      code: code ?? this.code,
      status: status ?? this.status,
      statusString: statusString ?? this.statusString,
      observationsVotes: observationsVotes ?? this.observationsVotes,
      dateTimeOfCreation: dateTimeOfCreation ?? this.dateTimeOfCreation,
      wasSawByOwner: wasSawByOwner ?? this.wasSawByOwner,
      authorizationProcessConfigItemType:
          authorizationProcessConfigItemType ??
          this.authorizationProcessConfigItemType,
      user: user ?? this.user,
      enterprise: enterprise ?? this.enterprise,
      authorizationProcessItem:
          authorizationProcessItem ?? this.authorizationProcessItem,
      authorizators: authorizators ?? this.authorizators,
      defendants: annulDefendants == true
          ? null
          : defendants ?? this.defendants,
      votes: votes ?? this.votes,
    );
  }
}
