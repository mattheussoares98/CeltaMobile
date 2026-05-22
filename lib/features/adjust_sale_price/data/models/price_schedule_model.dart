import 'package:equatable/equatable.dart';

import 'package:celta_inventario/features/adjust_sale_price/domain/entities/entities.dart';

class PriceScheduleModel extends Equatable {
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

  const PriceScheduleModel({
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

  factory PriceScheduleModel.fromJson(Map data) => PriceScheduleModel(
    Code: data['Code'] as int,
    FatherCode: data['FatherCode'] as int?,
    BrotherCode: data['BrotherCode'] as int?,
    User: data['User'] as String,
    Date: DateTime.parse(data['Date']),
    ExecutionDate: DateTime.parse(data['ExecutionDate']),
    ExecutedDate: data['ExecutedDate'] == null
        ? null
        : DateTime.parse(data['ExecutedDate']),
    PriceType: data['PriceType'] as int,
    PriceTypeString: data['PriceTypeString'] as String,
    OriginalPrice: data['OriginalPrice'] as double,
    Price: data['Price'] as double,
    LastPrice: data['LastPrice'] as double,
    RoundedPrice: data['RoundedPrice'] as bool,
    AlteredByEnterpriseGroup: data['AlteredByEnterpriseGroup'] as bool,
    AlteredByClass: data['AlteredByClass'] as bool,
    AlteredByPackings: data['AlteredByPackings'] as bool,
    AlteredByGrid: data['AlteredByGrid'] as bool,
    UpdateClass: data['UpdateClass'] as bool,
    UpdateEnterpriseOperationalGroup:
        data['UpdateEnterpriseOperationalGroup'] as bool,
    Origin: data['Origin'] as int,
    OriginString: data['OriginString'] as String,
    IsFather: data['IsFather'] as bool,
    IsBrother: data['IsBrother'] as bool,
    IsExecuted: data['IsExecuted'] as bool,
    IsFinished: data['IsFinished'] as bool,
    OfferSchedule: data['OfferSchedule'] as String,
  );

  Map<String, dynamic> toJson() => {
    'Code': Code,
    'FatherCode': FatherCode,
    'BrotherCode': BrotherCode,
    'User': User,
    'Date': Date.toIso8601String(),
    'ExecutionDate': ExecutionDate.toIso8601String(),
    'ExecutedDate': ExecutedDate?.toIso8601String(),
    'PriceType': PriceType,
    'PriceTypeString': PriceTypeString,
    'OriginalPrice': OriginalPrice,
    'Price': Price,
    'LastPrice': LastPrice,
    'RoundedPrice': RoundedPrice,
    'AlteredByEnterpriseGroup': AlteredByEnterpriseGroup,
    'AlteredByClass': AlteredByClass,
    'AlteredByPackings': AlteredByPackings,
    'AlteredByGrid': AlteredByGrid,
    'UpdateClass': UpdateClass,
    'UpdateEnterpriseOperationalGroup': UpdateEnterpriseOperationalGroup,
    'Origin': Origin,
    'OriginString': OriginString,
    'IsFather': IsFather,
    'IsBrother': IsBrother,
    'IsExecuted': IsExecuted,
    'IsFinished': IsFinished,
    'OfferSchedule': OfferSchedule,
  };

  factory PriceScheduleModel.fromEntity(PriceScheduleEntity entity) =>
      PriceScheduleModel(
        Code: entity.Code,
        FatherCode: entity.FatherCode,
        BrotherCode: entity.BrotherCode,
        User: entity.User,
        Date: entity.Date,
        ExecutionDate: entity.ExecutionDate,
        ExecutedDate: entity.ExecutedDate,
        PriceType: entity.PriceType,
        PriceTypeString: entity.PriceTypeString,
        OriginalPrice: entity.OriginalPrice,
        Price: entity.Price,
        LastPrice: entity.LastPrice,
        RoundedPrice: entity.RoundedPrice,
        AlteredByEnterpriseGroup: entity.AlteredByEnterpriseGroup,
        AlteredByClass: entity.AlteredByClass,
        AlteredByPackings: entity.AlteredByPackings,
        AlteredByGrid: entity.AlteredByGrid,
        UpdateClass: entity.UpdateClass,
        UpdateEnterpriseOperationalGroup:
            entity.UpdateEnterpriseOperationalGroup,
        Origin: entity.Origin,
        OriginString: entity.OriginString,
        IsFather: entity.IsFather,
        IsBrother: entity.IsBrother,
        IsExecuted: entity.IsExecuted,
        IsFinished: entity.IsFinished,
        OfferSchedule: entity.OfferSchedule,
      );

  PriceScheduleEntity toEntity() => PriceScheduleEntity(
    Code: Code,
    FatherCode: FatherCode,
    BrotherCode: BrotherCode,
    User: User,
    Date: Date,
    ExecutionDate: ExecutionDate,
    ExecutedDate: ExecutedDate,
    PriceType: PriceType,
    PriceTypeString: PriceTypeString,
    OriginalPrice: OriginalPrice,
    Price: Price,
    LastPrice: LastPrice,
    RoundedPrice: RoundedPrice,
    AlteredByEnterpriseGroup: AlteredByEnterpriseGroup,
    AlteredByClass: AlteredByClass,
    AlteredByPackings: AlteredByPackings,
    AlteredByGrid: AlteredByGrid,
    UpdateClass: UpdateClass,
    UpdateEnterpriseOperationalGroup: UpdateEnterpriseOperationalGroup,
    Origin: Origin,
    OriginString: OriginString,
    IsFather: IsFather,
    IsBrother: IsBrother,
    IsExecuted: IsExecuted,
    IsFinished: IsFinished,
    OfferSchedule: OfferSchedule,
  );
}
