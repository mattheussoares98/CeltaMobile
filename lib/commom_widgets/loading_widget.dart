import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class LoadingWidget extends StatelessWidget {
  final double? size;
  final String? title;
  const LoadingWidget({super.key, this.size = Sizes.p24, this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIos = theme.platform == TargetPlatform.iOS;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (title != null) ...[
          Text(
            title!,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300,
              fontSize:
                  (theme.textTheme.bodySmall?.fontSize ?? 12) * size! * 0.045,
            ),
          ),
          gapH16,
        ],
        Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: isIos
              ? CupertinoActivityIndicator(radius: size! * 0.5)
              : SizedBox(
                  width: size,
                  height: size,
                  child: const CircularProgressIndicator(),
                ),
        ),
      ],
    );
  }
}
