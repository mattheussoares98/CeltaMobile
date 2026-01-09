import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/constants/app_sizes.dart';
import 'commom_widgets.dart';

/// Primary button based on [ElevatedButton].
/// Useful for CTAs in the app.
/// @param text - text to display on the button.
/// @param isLoading - if true, a loading indicator will be displayed instead of
/// the text.
/// @param onPressed - callback to be called when the button is pressed.
class PrimaryTextButton extends StatelessWidget {
  const PrimaryTextButton({
    super.key,
    required this.text,
    this.isLoading = false,
    this.onPressed,
    this.icon,
    this.iconAlignment = IconAlignment.end,
    this.color,
    this.isSmall,
    this.textAlign = TextAlign.center,
  });
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;
  final Widget? icon;
  final IconAlignment? iconAlignment;
  final Color? color;
  final TextAlign? textAlign;
  final bool? isSmall;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    final iconColor = isLoading
        ? theme.disabledColor
        : color ?? theme.primaryColor;
    final textColor = isLoading
        ? Colors.transparent
        : color ?? theme.primaryColor;

    final textWidget = Text(
      text,
      textAlign: textAlign,
      style:
          (isSmall == true
                  ? theme.textTheme.titleSmall
                  : theme.textTheme.titleMedium)
              ?.copyWith(color: textColor),
    );
    final iconWidget = icon == null
        ? null
        : IconTheme(
            data: IconThemeData(
              color: iconColor,
              size: isSmall == true ? 16 : 24,
            ),
            child: icon!,
          );

    final minimumSizeToShowIcon = isSmall == true ? 60 : 150;

    if (isIOS) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final canShowIcon = constraints.maxWidth > minimumSizeToShowIcon;

          return CupertinoButton(
            onPressed: isLoading ? null : onPressed,
            sizeStyle: CupertinoButtonSize.small,
            padding: const EdgeInsets.all(0),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textWidget,
                    if (icon != null && canShowIcon) ...[gapW8, iconWidget!],
                  ],
                ),
                if (isLoading)
                  const Positioned.fill(
                    child: FittedBox(child: LoadingWidget(padding: 0)),
                  ),
              ],
            ),
          );
        },
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final canShowIcon = constraints.maxWidth > minimumSizeToShowIcon;

        return TextButton.icon(
          onPressed: isLoading ? null : onPressed,
          icon: canShowIcon ? iconWidget : null,
          iconAlignment: iconAlignment,
          label: Stack(
            children: [
              FittedBox(child: textWidget),
              if (isLoading)
                const Positioned.fill(
                  child: FittedBox(child: LoadingWidget(padding: 0)),
                ),
            ],
          ),
        );
      },
    );
  }
}
