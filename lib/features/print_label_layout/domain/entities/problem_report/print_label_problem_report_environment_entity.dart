import 'package:equatable/equatable.dart';

class PrintLabelProblemReportEnvironmentEntity extends Equatable {
  final String appVersion;
  final String operatingSystem;
  final String operatingSystemVersion;
  final String deviceModel;

  const PrintLabelProblemReportEnvironmentEntity({
    required this.appVersion,
    required this.operatingSystem,
    required this.operatingSystemVersion,
    required this.deviceModel,
  });

  @override
  List<Object?> get props => [
    appVersion,
    operatingSystem,
    operatingSystemVersion,
    deviceModel,
  ];
}
