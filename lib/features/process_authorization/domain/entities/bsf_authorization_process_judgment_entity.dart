// lib/features/process_authorization/domain/entities/bsf_authorization_process_judgment_entity.dart
import 'package:equatable/equatable.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';

class BSFAuthorizationProcessJudgmentEntity extends Equatable {
  final int? code;
  final BSFAuthorizationProcessJudgementStatus? status;
  final String? statusString;
  final String? observationsVotes;
  final DateTime? dateTimeOfCreation;
  final bool? wasSawByOwner;
  final int? authorizationProcessConfigItemType;
  final BSFUserEntity? user;
  final BSFEnterpriseEntity? enterprise;
  final BSFAuthorizationProcessItemEntity? authorizationProcessItem;
  final List<BSFUserEntity>? authorizators;

  const BSFAuthorizationProcessJudgmentEntity({
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
      ];
}
