import 'package:equatable/equatable.dart';

class PriceScheduleEntity extends Equatable {
  final int Code;
  final int? FatherCode;
  final int? BrotherCode;
  final String User;
  final DateTime Date;
  final DateTime ExecutionDate;
  final DateTime? ExecutedDate;
  final int PriceType;
  final String PriceTypeString;
  final double OriginalPrice;
  final double Price;
  final double LastPrice;
  final bool RoundedPrice;
  final bool AlteredByEnterpriseGroup;
  final bool AlteredByClass;
  final bool AlteredByPackings;
  final bool AlteredByGrid;
  final bool UpdateClass;
  final bool UpdateEnterpriseOperationalGroup;
  final int Origin;
  final String OriginString;
  final bool IsFather;
  final bool IsBrother;
  final bool IsExecuted;
  final bool IsFinished;
  final String OfferSchedule;

  const PriceScheduleEntity({
    required this.Code,
    required this.FatherCode,
    required this.BrotherCode,
    required this.User,
    required this.Date,
    required this.ExecutionDate,
    required this.ExecutedDate,
    required this.PriceType,
    required this.PriceTypeString,
    required this.OriginalPrice,
    required this.Price,
    required this.LastPrice,
    required this.RoundedPrice,
    required this.AlteredByEnterpriseGroup,
    required this.AlteredByClass,
    required this.AlteredByPackings,
    required this.AlteredByGrid,
    required this.UpdateClass,
    required this.UpdateEnterpriseOperationalGroup,
    required this.Origin,
    required this.OriginString,
    required this.IsFather,
    required this.IsBrother,
    required this.IsExecuted,
    required this.IsFinished,
    required this.OfferSchedule,
  });

  @override
  List<Object?> get props => [
    Code,
    FatherCode,
    BrotherCode,
    User,
    Date,
    ExecutionDate,
    ExecutedDate,
    PriceType,
    PriceTypeString,
    OriginalPrice,
    Price,
    LastPrice,
    RoundedPrice,
    AlteredByEnterpriseGroup,
    AlteredByClass,
    AlteredByPackings,
    AlteredByGrid,
    UpdateClass,
    UpdateEnterpriseOperationalGroup,
    Origin,
    OriginString,
    IsFather,
    IsBrother,
    IsExecuted,
    IsFinished,
    OfferSchedule,
  ];
}
