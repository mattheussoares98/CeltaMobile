import 'package:equatable/equatable.dart';

import '../entities.dart';

enum BSFSearchRequestType { approximateName }

class BSFSearchRequestTypeParametersEntity extends Equatable {
  final BSFSearchRequestType searchType;
  final String simpleSearchValue;
  final bool makeEnterprises;
  final bool makeFiscalNoteTypes;
  final bool makeRequestTypeForTransfer;
  final bool makeFiscalCodes;
  final bool makeUserGroups;
  final bool makeUsers;
  final bool makePaymentFinalizations;
  final bool makeSendEmailParameters;
  final BSFSearchRequestTypeBehaviorBasicFiltersEntity? behaviorBasicFilters;

  const BSFSearchRequestTypeParametersEntity({
    this.searchType = BSFSearchRequestType.approximateName,
    this.simpleSearchValue = '',
    this.makeEnterprises = false,
    this.makeFiscalNoteTypes = false,
    this.makeRequestTypeForTransfer = false,
    this.makeFiscalCodes = false,
    this.makeUserGroups = false,
    this.makeUsers = false,
    this.makePaymentFinalizations = false,
    this.makeSendEmailParameters = false,
    this.behaviorBasicFilters,
  });

  @override
  List<Object?> get props => [
    searchType,
    simpleSearchValue,
    makeEnterprises,
    makeFiscalNoteTypes,
    makeRequestTypeForTransfer,
    makeFiscalCodes,
    makeUserGroups,
    makeUsers,
    makePaymentFinalizations,
    makeSendEmailParameters,
    behaviorBasicFilters,
  ];
}
