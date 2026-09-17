import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/app_sizes.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrimaryButton extends ConsumerWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    this.isLoading = false,
    this.onPressed,
    this.icon,
    this.iconAlignment,
    this.backgroundColor,
  });
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;
  final Widget? icon;
  final IconAlignment? iconAlignment;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isIOS = PlatformUtil.isCupertino;

    final textWidget = BaseText.titleMedium(
      text,
      textAlign: TextAlign.center,
      color: isLoading ? Colors.transparent : Colors.white,
    );

    const minimumIconSize = 150;
    const loadingWidget = Center(child: FittedBox(child: LoadingWidget()));
    const buttonHeight = Sizes.p40;

    final buttonColor = onPressed == null || isLoading
        ? context.theme.disabledColor.withAlpha(30)
        : backgroundColor ?? context.theme.primaryColor;

    void appliedOnPress() {
      FocusManager.instance.primaryFocus?.unfocus();
      onPressed?.call();
    }

    if (isIOS) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final canShowIcon = constraints.maxWidth > minimumIconSize;

          return SizedBox(
            height: buttonHeight,
            child: CupertinoButton.filled(
              onPressed: onPressed == null || isLoading ? null : appliedOnPress,
              sizeStyle: CupertinoButtonSize.medium,
              padding: const EdgeInsets.symmetric(
                vertical: Sizes.p8,
                horizontal: Sizes.p8,
              ),
              color: buttonColor,
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: FittedBox(child: textWidget)),
                      if (icon != null && canShowIcon)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Sizes.p16,
                          ),
                          child: icon!,
                        ),
                    ],
                  ),
                  if (isLoading) loadingWidget,
                ],
              ),
            ),
          );
        },
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final canShowIcon = constraints.maxWidth > minimumIconSize;

        return SizedBox(
          height: buttonHeight,
          child: ElevatedButton.icon(
            onPressed: onPressed == null || isLoading ? null : appliedOnPress,
            icon: canShowIcon ? icon : null,
            iconAlignment: iconAlignment,
            style: ButtonStyle(
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: Sizes.p8),
              ),
              backgroundColor: WidgetStateProperty.all(buttonColor),
            ),
            label: Stack(
              children: [
                FittedBox(child: textWidget),
                if (isLoading) loadingWidget,
              ],
            ),
          ),
        );
      },
    );
  }
}
