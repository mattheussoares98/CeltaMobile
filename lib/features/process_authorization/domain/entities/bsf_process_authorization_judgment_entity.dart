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
  ];
}
