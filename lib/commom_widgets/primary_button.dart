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
  });
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;
  final Widget? icon;
  final IconAlignment? iconAlignment;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Sizes.p32,
      child: ElevatedButton.icon(
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
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
              ),
      ),
    );
  }
}
