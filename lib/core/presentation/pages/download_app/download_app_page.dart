import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/presentation/controllers/url_launch/url_launch.dart';

class DownloadAppPage extends ConsumerWidget {
  const DownloadAppPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? url;
    final theme = Theme.of(context);
    final isAndroid = theme.platform == TargetPlatform.android;
    final isIOS = theme.platform == TargetPlatform.iOS;
    if (isAndroid) {
      url =
          'https://play.google.com/store/apps/details?id=br.com.celtaware.inventario&pcampaignid=web_share';
    } else if (isIOS) {
      url = 'https://apps.apple.com/br/app/celta-mobile/id6504156890';
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Faça o download do app para utilizar'.hardcoded),
            PrimaryTextButton(
              text: 'Baixar'.hardcoded,
              onPressed: url == null
                  ? null
                  : () {
                      ref
                          .read(urlLaunchControllerProvider.notifier)
                          .launch(url!);
                    },
            ),
          ],
        ),
      ),
    );
  }
}
