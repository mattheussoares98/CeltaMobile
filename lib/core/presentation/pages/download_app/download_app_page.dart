import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../controllers/url_launch/url_launch.dart';

class DownloadAppPage extends ConsumerWidget {
  const DownloadAppPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? url;
    if (defaultTargetPlatform == TargetPlatform.android) {
      url =
          'https://play.google.com/store/apps/details?id=br.com.celtaware.inventario&pcampaignid=web_share';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      url = 'https://apps.apple.com/br/app/celta-mobile/id6504156890';
    }

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Faça o download do app para utilizar'.hardcoded),
            PrimaryTextButton(
              text: 'Baixar'.hardcoded,
              onPressed: url == null
                  ? null
                  : () {
                      ref
                          .read(urlLaunchControllerProvider.notifier)
                          .launch(
                            'https://play.google.com/store/apps/details?id=br.com.celtaware.inventario&pcampaignid=web_share',
                          );
                    },
            ),
          ],
        ),
      ),
    );
  }
}
