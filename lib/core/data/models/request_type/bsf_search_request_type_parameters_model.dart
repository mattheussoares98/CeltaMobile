import '../../../domain/entities/entities.dart';

class BSFSearchRequestTypeParametersModel
    extends BSFSearchRequestTypeParametersEntity {
  const BSFSearchRequestTypeParametersModel({
    super.searchType,
    super.simpleSearchValue,
    super.makeEnterprises,
    super.makeFiscalNoteTypes,
    super.makeRequestTypeForTransfer,
    super.makeFiscalCodes,
    super.makeUserGroups,
    super.makeUsers,
    super.makePaymentFinalizations,
    super.makeSendEmailParameters,
  });

  factory BSFSearchRequestTypeParametersModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      BSFSearchRequestTypeParametersModel(
        searchType: BSFSearchRequestType.values[json['SearchType'] as int],
        simpleSearchValue: json['SimpleSearchValue'] as String? ?? '',
        makeEnterprises: json['MakeEnterprises'] as bool? ?? false,
        makeFiscalNoteTypes: json['MakeFiscalNoteTypes'] as bool? ?? false,
        makeRequestTypeForTransfer:
            json['MakeRequestTypeForTransfer'] as bool? ?? false,
        makeFiscalCodes: json['MakeFiscalCodes'] as bool? ?? false,
        makeUserGroups: json['MakeUserGroups'] as bool? ?? false,
        makeUsers: json['MakeUsers'] as bool? ?? false,
        makePaymentFinalizations:
            json['MakePaymentFinalizations'] as bool? ?? false,
        makeSendEmailParameters:
            json['MakeSendEmailParameters'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'SearchType': searchType.index,
        'SimpleSearchValue': simpleSearchValue,
        'MakeEnterprises': makeEnterprises,
        'MakeFiscalNoteTypes': makeFiscalNoteTypes,
        'MakeRequestTypeForTransfer': makeRequestTypeForTransfer,
        'MakeFiscalCodes': makeFiscalCodes,
        'MakeUserGroups': makeUserGroups,
        'MakeUsers': makeUsers,
        'MakePaymentFinalizations': makePaymentFinalizations,
        'MakeSendEmailParameters': makeSendEmailParameters,
      };

  factory BSFSearchRequestTypeParametersModel.fromEntity(
    BSFSearchRequestTypeParametersEntity entity,
  ) =>
      BSFSearchRequestTypeParametersModel(
        searchType: entity.searchType,
        simpleSearchValue: entity.simpleSearchValue,
        makeEnterprises: entity.makeEnterprises,
        makeFiscalNoteTypes: entity.makeFiscalNoteTypes,
        makeRequestTypeForTransfer: entity.makeRequestTypeForTransfer,
        makeFiscalCodes: entity.makeFiscalCodes,
        makeUserGroups: entity.makeUserGroups,
        makeUsers: entity.makeUsers,
        makePaymentFinalizations: entity.makePaymentFinalizations,
        makeSendEmailParameters: entity.makeSendEmailParameters,
      );

  BSFSearchRequestTypeParametersEntity toEntity() =>
      BSFSearchRequestTypeParametersEntity(
        searchType: searchType,
        simpleSearchValue: simpleSearchValue,
        makeEnterprises: makeEnterprises,
        makeFiscalNoteTypes: makeFiscalNoteTypes,
        makeRequestTypeForTransfer: makeRequestTypeForTransfer,
        makeFiscalCodes: makeFiscalCodes,
        makeUserGroups: makeUserGroups,
        makeUsers: makeUsers,
        makePaymentFinalizations: makePaymentFinalizations,
        makeSendEmailParameters: makeSendEmailParameters,
      );
}
