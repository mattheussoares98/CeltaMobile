// lib/features/process_authorization/data/models/bsf_user_model.dart
import 'package:celta_inventario/features/process_authorization/data/models/models.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';

class BSFUserModel extends BSFUserEntity {
  const BSFUserModel({
    super.code,
    super.isInternalUser,
    super.excludedUser,
    super.isBuyer,
    super.isSeller,
    super.isAdministrator,
    super.isTimeForChangePassword,
    super.identification,
    super.emailSignature,
    super.containsMd5Password,
    super.cipCode,
    super.changePasswordNextLogin,
    super.lastPasswordChange,
    super.passwordExpiration,
    super.canLogin,
    super.crossIdentity,
    super.bondType,
  });

  factory BSFUserModel.fromJson(Map json) => BSFUserModel(
        code: json['Code'],
        isInternalUser: json['IsInternalUser'],
        excludedUser: json['ExcludedUser'],
        isBuyer: json['IsBuyer'],
        isSeller: json['IsSeller'],
        isAdministrator: json['IsAdministrator'],
        isTimeForChangePassword: json['IsTimeForChangePassword'],
        identification: json['Identification']?.toString(),
        emailSignature: json['EmailSignature']?.toString(),
        containsMd5Password: json['ContainsMd5Password'],
        cipCode: json['CipCode'],
        changePasswordNextLogin: json['ChangePasswordNextLogin'],
        lastPasswordChange: json['LastPasswordChange'] != null
            ? DateTime.parse(json['LastPasswordChange'])
            : null,
        passwordExpiration: json['PasswordExpiration'],
        canLogin: json['CanLogin'],
        crossIdentity: json['CrossIdentity'] != null
            ? BSFCrossIdentityModel.fromJson(json['CrossIdentity'])
            : null,
        bondType: BSFUserBondType.fromValue(json['BondType']),
      );

  Map<String, dynamic> toJson() => {
        'Code': code,
        'IsInternalUser': isInternalUser,
        'ExcludedUser': excludedUser,
        'IsBuyer': isBuyer,
        'IsSeller': isSeller,
        'IsAdministrator': isAdministrator,
        'IsTimeForChangePassword': isTimeForChangePassword,
        'Identification': identification,
        'EmailSignature': emailSignature,
        'ContainsMd5Password': containsMd5Password,
        'CipCode': cipCode,
        'ChangePasswordNextLogin': changePasswordNextLogin,
        'LastPasswordChange': lastPasswordChange?.toIso8601String(),
        'PasswordExpiration': passwordExpiration,
        'CanLogin': canLogin,
        'CrossIdentity': crossIdentity != null
            ? BSFCrossIdentityModel.fromEntity(crossIdentity!).toJson()
            : null,
        'BondType': bondType?.value,
      };

  factory BSFUserModel.fromEntity(BSFUserEntity entity) => BSFUserModel(
        code: entity.code,
        isInternalUser: entity.isInternalUser,
        excludedUser: entity.excludedUser,
        isBuyer: entity.isBuyer,
        isSeller: entity.isSeller,
        isAdministrator: entity.isAdministrator,
        isTimeForChangePassword: entity.isTimeForChangePassword,
        identification: entity.identification,
        emailSignature: entity.emailSignature,
        containsMd5Password: entity.containsMd5Password,
        cipCode: entity.cipCode,
        changePasswordNextLogin: entity.changePasswordNextLogin,
        lastPasswordChange: entity.lastPasswordChange,
        passwordExpiration: entity.passwordExpiration,
        canLogin: entity.canLogin,
        crossIdentity: entity.crossIdentity,
        bondType: entity.bondType,
      );

  BSFUserEntity toEntity() => BSFUserEntity(
        code: code,
        isInternalUser: isInternalUser,
        excludedUser: excludedUser,
        isBuyer: isBuyer,
        isSeller: isSeller,
        isAdministrator: isAdministrator,
        isTimeForChangePassword: isTimeForChangePassword,
        identification: identification,
        emailSignature: emailSignature,
        containsMd5Password: containsMd5Password,
        cipCode: cipCode,
        changePasswordNextLogin: changePasswordNextLogin,
        lastPasswordChange: lastPasswordChange,
        passwordExpiration: passwordExpiration,
        canLogin: canLogin,
        crossIdentity: crossIdentity,
        bondType: bondType,
      );
}
