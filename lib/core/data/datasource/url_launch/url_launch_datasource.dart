import 'package:url_launcher/url_launcher.dart';

import '../../../../exceptions/exceptions.dart';
import 'url_launch.dart';

class UrlLaunchDatasource implements IUrlLaunchDatasource {
  @override
  Future<void> launch(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw AppException('Não foi possível abrir $url');
    }
  }
}
