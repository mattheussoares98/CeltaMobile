import '../../../domain/entities/entities.dart';
import '../models.dart';

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
    super.behaviorBasicFilters,
  });

  factory BSFSearchRequestTypeParametersModel.fromJson(
    Map<String, dynamic> json,
  ) {
    // Note: Behaviors extraction is simplified for now as we only support one type
    BSFSearchRequestTypeBehaviorBasicFiltersModel? behaviorBasicFilters;
    final behaviorsJson = json['Behaviors'] as List?;
    if (behaviorsJson != null) {
      for (final behavior in behaviorsJson) {
        if (behavior['\$type']?.contains(
              'SearchRequestTypeBehaviorBasicFilters',
            ) ??
            false) {
          behaviorBasicFilters =
              BSFSearchRequestTypeBehaviorBasicFiltersModel.fromJson(behavior);
        }
      }
    }

    return BSFSearchRequestTypeParametersModel(
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
      behaviorBasicFilters: behaviorBasicFilters,
    );
  }

  Map<String, dynamic> toJson() => {
    'SearchType': searchType.name,
    'SimpleSearchValue': simpleSearchValue,
    'MakeEnterprises': makeEnterprises,
    'MakeFiscalNoteTypes': makeFiscalNoteTypes,
    'MakeRequestTypeForTransfer': makeRequestTypeForTransfer,
    'MakeFiscalCodes': makeFiscalCodes,
    'MakeUserGroups': makeUserGroups,
    'MakeUsers': makeUsers,
    'MakePaymentFinalizations': makePaymentFinalizations,
    'MakeSendEmailParameters': makeSendEmailParameters,
    'ContainBasicFilters': behaviorBasicFilters != null,
    'Behaviors': [
      if (behaviorBasicFilters != null)
        BSFSearchRequestTypeBehaviorBasicFiltersModel.fromEntity(
          behaviorBasicFilters!,
        ).toJson(),
    ],
  };

  factory BSFSearchRequestTypeParametersModel.fromEntity(
    BSFSearchRequestTypeParametersEntity entity,
  ) => BSFSearchRequestTypeParametersModel(
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
    behaviorBasicFilters: entity.behaviorBasicFilters,
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
        behaviorBasicFilters: behaviorBasicFilters,
      );
}
