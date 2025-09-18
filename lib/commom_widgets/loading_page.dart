import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIos = theme.platform == TargetPlatform.iOS;
    final double size = isIos ? Sizes.p32 : Sizes.p48;

    return Scaffold(
      backgroundColor: theme.disabledColor.withAlpha(50),
      body: Center(
        child: isIos
            ? CupertinoActivityIndicator(radius: size)
            : SizedBox(
                width: size,
                height: size,
                child: const CircularProgressIndicator(),
              ),
      ),
    );
  }
}
