import 'package:flutter/material.dart';
import '/constants/app_sizes.dart';

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
  });
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;
  final Widget? icon;
  final IconAlignment? iconAlignment;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: Sizes.p24,
      child: TextButton.icon(
        onPressed: onPressed,
        icon: icon,
        iconAlignment: iconAlignment,
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
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.primaryColorDark,
                  ),
                ),
              ),
      ),
    );
  }
}
