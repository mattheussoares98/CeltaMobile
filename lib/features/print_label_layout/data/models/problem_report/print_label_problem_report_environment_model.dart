import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';

class PrintLabelProblemReportEnvironmentModel
    extends PrintLabelProblemReportEnvironmentEntity {
  const PrintLabelProblemReportEnvironmentModel({
    required super.appVersion,
    required super.operatingSystem,
    required super.operatingSystemVersion,
    required super.deviceModel,
  });

  factory PrintLabelProblemReportEnvironmentModel.fromJson(Map json) =>
      PrintLabelProblemReportEnvironmentModel(
        appVersion: json['app_version'] as String,
        operatingSystem: json['operating_system'] as String,
        operatingSystemVersion: json['operating_system_version'] as String,
        deviceModel: json['device_model'] as String,
      );

  factory PrintLabelProblemReportEnvironmentModel.fromEntity(
    PrintLabelProblemReportEnvironmentEntity entity,
  ) => PrintLabelProblemReportEnvironmentModel(
    appVersion: entity.appVersion,
    operatingSystem: entity.operatingSystem,
    operatingSystemVersion: entity.operatingSystemVersion,
    deviceModel: entity.deviceModel,
  );

  Map toJson() => {
    'app_version': appVersion,
    'operating_system': operatingSystem,
    'operating_system_version': operatingSystemVersion,
    'device_model': deviceModel,
  };

  PrintLabelProblemReportEnvironmentEntity toEntity() =>
      PrintLabelProblemReportEnvironmentEntity(
        appVersion: appVersion,
        operatingSystem: operatingSystem,
        operatingSystemVersion: operatingSystemVersion,
        deviceModel: deviceModel,
      );
}
