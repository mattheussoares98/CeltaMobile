// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'entities.dart';

class DownloadExecutionEntity extends Equatable {
  final ScheduleExecutionsEntity executionResult;
  final String? xlsxFilePath;

  const DownloadExecutionEntity({
    required this.executionResult,
    this.xlsxFilePath,
  });

  @override
  List<Object?> get props => [executionResult, xlsxFilePath];

  DownloadExecutionEntity copyWith({
    ScheduleExecutionsEntity? executionResult,
    String? xlsxFilePath,
  }) {
    return DownloadExecutionEntity(
      executionResult: executionResult ?? this.executionResult,
      xlsxFilePath: xlsxFilePath ?? this.xlsxFilePath,
    );
  }
}
