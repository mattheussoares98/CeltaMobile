import 'package:equatable/equatable.dart';

class ReportScheduleEntity extends Equatable {
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

  const ReportScheduleEntity({
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
