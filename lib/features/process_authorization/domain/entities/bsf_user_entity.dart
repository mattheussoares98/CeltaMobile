// lib/features/process_authorization/domain/entities/bsf_user_entity.dart
import 'package:equatable/equatable.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';

class BSFUserEntity extends Equatable {
  final int? code;
  final bool? isInternalUser;
  final bool? excludedUser;
  final bool? isBuyer;
  final bool? isSeller;
  final bool? isAdministrator;
  final bool? isTimeForChangePassword;
  final String? identification;
  final String? emailSignature;
  final bool? containsMd5Password;
  final int? cipCode;
  final bool? changePasswordNextLogin;
  final DateTime? lastPasswordChange;
  final int? passwordExpiration;
  final bool? canLogin;
  final BSFCrossIdentityEntity? crossIdentity;
  final int? bondType;

  const BSFUserEntity({
    this.code,
    this.isInternalUser,
    this.excludedUser,
    this.isBuyer,
    this.isSeller,
    this.isAdministrator,
    this.isTimeForChangePassword,
    this.identification,
    this.emailSignature,
    this.containsMd5Password,
    this.cipCode,
    this.changePasswordNextLogin,
    this.lastPasswordChange,
    this.passwordExpiration,
    this.canLogin,
    this.crossIdentity,
    this.bondType,
  });

  @override
  List<Object?> get props => [
        code,
        isInternalUser,
        excludedUser,
        isBuyer,
        isSeller,
        isAdministrator,
        isTimeForChangePassword,
        identification,
        emailSignature,
        containsMd5Password,
        cipCode,
        changePasswordNextLogin,
        lastPasswordChange,
        passwordExpiration,
        canLogin,
        crossIdentity,
        bondType,
      ];
}
