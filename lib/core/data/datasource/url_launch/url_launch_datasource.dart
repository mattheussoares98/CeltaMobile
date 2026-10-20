import 'package:celta_inventario/core/domain/errors/errors.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/core/data/datasource/url_launch/url_launch.dart';

class UrlLaunchDatasource implements IUrlLaunchDatasource {
  @override
  Future<void> launch(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw AppException.localized(CoreFailure.cannotOpenUrl, [url]);
    }
  }
}
