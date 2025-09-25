import 'package:flutter/material.dart';

import '../constants/constants.dart';
import 'commom_widgets.dart';

class LoadingPage extends StatelessWidget {
  final String? title;
  const LoadingPage({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIos = theme.platform == TargetPlatform.iOS;
    final double size = isIos ? Sizes.p32 : Sizes.p48;

    return Scaffold(
      backgroundColor: theme.disabledColor.withAlpha(50),
      body: LoadingWidget(size: size, title: title),
    );
  }
}
