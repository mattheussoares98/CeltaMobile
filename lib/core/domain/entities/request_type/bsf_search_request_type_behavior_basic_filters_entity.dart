import 'package:equatable/equatable.dart';

class BSFSearchRequestTypeBehaviorBasicFiltersEntity extends Equatable {
  final List<int>? codesForIn;
  final int fiscalNoteTypeCode;
  final int enterpriseCode;
  final int userCode;
  final bool inclusiveBuy;
  final bool inclusiveTransfer;
  final bool inclusiveSale;
  final bool onlyContainTransferValueDefined;
  final bool onlyContainFiscalNoteDefined;

  const BSFSearchRequestTypeBehaviorBasicFiltersEntity({
    this.codesForIn,
    this.fiscalNoteTypeCode = 0,
    this.enterpriseCode = 0,
    this.userCode = 0,
    this.inclusiveBuy = false,
    this.inclusiveTransfer = false,
    this.inclusiveSale = false,
    this.onlyContainTransferValueDefined = false,
    this.onlyContainFiscalNoteDefined = false,
  });

  @override
  List<Object?> get props => [
        codesForIn,
        fiscalNoteTypeCode,
        enterpriseCode,
        userCode,
        inclusiveBuy,
        inclusiveTransfer,
        inclusiveSale,
        onlyContainTransferValueDefined,
        onlyContainFiscalNoteDefined,
      ];
}
