import 'dart:io';

import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/domain/services/services.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PrintLabelProblemReportEnvironmentService
    implements IPrintLabelProblemReportEnvironmentService {
  @override
  Future<PrintLabelProblemReportEnvironmentEntity> load() async {
    final appVersion = (await PackageInfo.fromPlatform()).version;
    final deviceInfo = DeviceInfoPlugin();
    if (kIsWeb) {
      final info = await deviceInfo.webBrowserInfo;
      return PrintLabelProblemReportEnvironmentEntity(
        appVersion: appVersion,
        operatingSystem: 'web',
        operatingSystemVersion: info.userAgent ?? 'unknown',
        deviceModel: info.browserName.name,
      );
    }
    if (PlatformUtil.isAndroid) {
      final info = await deviceInfo.androidInfo;
      return PrintLabelProblemReportEnvironmentEntity(
        appVersion: appVersion,
        operatingSystem: 'android',
        operatingSystemVersion: info.version.release,
        deviceModel: info.model,
      );
    }
    if (PlatformUtil.isIOS) {
      final info = await deviceInfo.iosInfo;
      return PrintLabelProblemReportEnvironmentEntity(
        appVersion: appVersion,
        operatingSystem: 'ios',
        operatingSystemVersion: info.systemVersion,
        deviceModel: info.utsname.machine,
      );
    }
    if (PlatformUtil.isWindows) {
      final info = await deviceInfo.windowsInfo;
      return PrintLabelProblemReportEnvironmentEntity(
        appVersion: appVersion,
        operatingSystem: 'windows',
        operatingSystemVersion: info.displayVersion,
        deviceModel: info.computerName,
      );
    }
    return PrintLabelProblemReportEnvironmentEntity(
      appVersion: appVersion,
      operatingSystem: Platform.operatingSystem,
      operatingSystemVersion: Platform.operatingSystemVersion,
      deviceModel: Platform.localHostname,
    );
  }
}
