import 'package:package_info_plus/package_info_plus.dart';

import 'app_version.dart';

class LoadAppVersionDatasource implements ILoadAppVersionDatasource {
  @override
  Future<String> get() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }
}
