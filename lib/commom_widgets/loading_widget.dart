import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final double? size;
  final String? title;
  final double? padding;
  const LoadingWidget({
    super.key,
    this.size = Sizes.p24,
    this.title,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isIos = PlatformUtil.isCupertino;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (title != null) ...[
          Text(
            title!,
            textAlign: TextAlign.center,
            style: context.theme.textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300,
              fontSize:
                  (context.theme.textTheme.bodySmall?.fontSize ?? 12) *
                  size! *
                  0.045,
            ),
          ),
          gapH16,
        ],
        RepaintBoundary(
          child: Padding(
            padding: EdgeInsets.all(padding ?? Sizes.p16),
            child: isIos
                ? CupertinoActivityIndicator(radius: size! * 0.5)
                : SizedBox(
                    width: size,
                    height: size,
                    child: const CircularProgressIndicator(),
                  ),
          ),
        ),
      ],
    );
  }
}
