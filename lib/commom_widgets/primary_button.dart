import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/constants/app_sizes.dart';

/// Primary button based on [ElevatedButton].
/// Useful for CTAs in the app.
/// @param text - text to display on the button.
/// @param isLoading - if true, a loading indicator will be displayed instead of
/// the text.
/// @param onPressed - callback to be called when the button is pressed.
class PrimaryButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (theme.platform == TargetPlatform.iOS) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return CupertinoButton.filled(
            onPressed: isLoading ? null : onPressed,
            sizeStyle: CupertinoButtonSize.small,
            padding: EdgeInsets.all(0),
            color: backgroundColor ?? theme.primaryColor,
            child: isLoading
                ? CupertinoActivityIndicator(color: theme.disabledColor)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: Text(text, textAlign: TextAlign.center)),
                      if (icon != null && constraints.maxWidth > 220)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Sizes.p8,
                          ),
                          child: icon!,
                        ),
                    ],
                  ),
          );
        },
      );
    }

    return SizedBox(
      height: Sizes.p32,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon,
        iconAlignment: iconAlignment,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            backgroundColor ?? theme.primaryColor,
          ),
        ),
        label: isLoading
            ? SizedBox(
                height: Sizes.p24,
                width: Sizes.p24,
                child: const CircularProgressIndicator(),
              )
            : FittedBox(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
              ),
      ),
    );
  }
}
