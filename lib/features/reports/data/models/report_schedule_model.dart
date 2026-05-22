import 'package:equatable/equatable.dart';

import 'package:celta_inventario/features/reports/domain/entities/entities.dart';

class ReportScheduleModel extends Equatable {
  final String Name;
  final String Type;
  final String CategoryName;
  final String SubCategoryName;
  final String ReportName;
  final String ReportModelName;
  final bool IsExecuting;
  final bool ExecutionStatus;
  final bool LastExecutionContainsData;
  final int Code;
  final int CategoryCode;
  final int SubCategoryCode;
  final int ReportCode;
  final int ReportModelCode;
  final DateTime? LastExecutionDate;
  final DateTime? LastExecutionStartDateTime;

  const ReportScheduleModel({
    required this.Name,
    required this.Type,
    required this.CategoryName,
    required this.SubCategoryName,
    required this.ReportName,
    required this.ReportModelName,
    required this.IsExecuting,
    required this.ExecutionStatus,
    required this.LastExecutionContainsData,
    required this.Code,
    required this.CategoryCode,
    required this.SubCategoryCode,
    required this.ReportCode,
    required this.ReportModelCode,
    required this.LastExecutionDate,
    required this.LastExecutionStartDateTime,
  });

  factory ReportScheduleModel.fromJson(Map json) {
    return ReportScheduleModel(
      Code: json["Code"],
      Name: json["Name"],
      Type: json["Type"],
      CategoryCode: json["CategoryCode"],
      CategoryName: json["CategoryName"],
      SubCategoryCode: json["SubCategoryCode"],
      SubCategoryName: json["SubCategoryName"],
      ReportCode: json["ReportCode"],
      ReportName: json["ReportName"],
      ReportModelCode: json["ReportModelCode"],
      ReportModelName: json["ReportModelName"],
      ExecutionStatus: json["ExecutionStatus"],
      IsExecuting: json["IsExecuting"],
      LastExecutionContainsData: json["LastExecutionContainsData"] == true,
      LastExecutionStartDateTime: json["LastExecutionStartDateTime"] != null
          ? DateTime.parse(json["LastExecutionStartDateTime"])
          : null,
      LastExecutionDate: json["LastExecutionDate"] != null
          ? DateTime.parse(json["LastExecutionDate"])
          : null,
    );
  }

  Map toJson() => {
    'Name': Name,
    'Type': Type,
    'CategoryName': CategoryName,
    'SubCategoryName': SubCategoryName,
    'ReportName': ReportName,
    'ReportModelName': ReportModelName,
    'IsExecuting': IsExecuting,
    'ExecutionStatus': ExecutionStatus,
    'LastExecutionContainsData': LastExecutionContainsData,
    'Code': Code,
    'CategoryCode': CategoryCode,
    'SubCategoryCode': SubCategoryCode,
    'ReportCode': ReportCode,
    'ReportModelCode': ReportModelCode,
    'LastExecutionDate': LastExecutionDate?.toIso8601String(),
    'LastExecutionStartDateTime': LastExecutionStartDateTime?.toIso8601String(),
  };

  factory ReportScheduleModel.fromEntity(ReportScheduleEntity entity) {
    return ReportScheduleModel(
      Code: entity.Code,
      Name: entity.Name,
      Type: entity.Type,
      CategoryCode: entity.CategoryCode,
      CategoryName: entity.CategoryName,
      SubCategoryCode: entity.SubCategoryCode,
      SubCategoryName: entity.SubCategoryName,
      ReportCode: entity.ReportCode,
      ReportName: entity.ReportName,
      ReportModelCode: entity.ReportModelCode,
      ReportModelName: entity.ReportModelName,
      ExecutionStatus: entity.ExecutionStatus,
      IsExecuting: entity.IsExecuting,
      LastExecutionContainsData: entity.LastExecutionContainsData,
      LastExecutionStartDateTime: entity.LastExecutionStartDateTime,
      LastExecutionDate: entity.LastExecutionDate,
    );
  }

  ReportScheduleEntity toEntity() {
    return ReportScheduleEntity(
      Code: Code,
      Name: Name,
      Type: Type,
      CategoryCode: CategoryCode,
      CategoryName: CategoryName,
      SubCategoryCode: SubCategoryCode,
      SubCategoryName: SubCategoryName,
      ReportCode: ReportCode,
      ReportName: ReportName,
      ReportModelCode: ReportModelCode,
      ReportModelName: ReportModelName,
      ExecutionStatus: ExecutionStatus,
      IsExecuting: IsExecuting,
      LastExecutionContainsData: LastExecutionContainsData,
      LastExecutionStartDateTime: LastExecutionStartDateTime,
      LastExecutionDate: LastExecutionDate,
    );
  }

  @override
  List<Object?> get props => [
    Name,
    Type,
    CategoryName,
    SubCategoryName,
    ReportName,
    ReportModelName,
    IsExecuting,
    ExecutionStatus,
    LastExecutionContainsData,
    Code,
    CategoryCode,
    SubCategoryCode,
    ReportCode,
    ReportModelCode,
    LastExecutionDate,
    LastExecutionStartDateTime,
  ];
}
