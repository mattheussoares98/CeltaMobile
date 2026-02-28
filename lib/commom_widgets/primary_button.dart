import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../features/auth/presentation/controllers/controllers.dart';
import '/constants/app_sizes.dart';
import 'commom_widgets.dart';

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
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    final isLoading = ref.watch(
      loginControllerProvider.select((s) => s.isLoading),
    );

    final textWidget = Text(
      text,
      textAlign: TextAlign.center,
      style: theme.textTheme.titleMedium?.copyWith(
        color: isLoading ? Colors.transparent : Colors.white,
      ),
    );

    const minimumIconSize = 150;

    final buttonColor = onPressed == null || isLoading
        ? theme.disabledColor.withAlpha(30)
        : backgroundColor ?? theme.primaryColor;

    const loadingWidget = Positioned.fill(child: LoadingWidget(padding: 0));

    if (isIOS) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final canShowIcon = constraints.maxWidth > minimumIconSize;

          return CupertinoButton.filled(
            onPressed: onPressed == null || isLoading
                ? null
                : () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    onPressed?.call();
                  },
            sizeStyle: CupertinoButtonSize.medium,
            padding: const EdgeInsets.all(0),
            color: buttonColor,
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: textWidget),
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
          );
        },
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final canShowIcon = constraints.maxWidth > minimumIconSize;

        return SizedBox(
          height: Sizes.p40,
          child: ElevatedButton.icon(
            onPressed: onPressed == null || isLoading
                ? null
                : () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    onPressed?.call();
                  },
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
