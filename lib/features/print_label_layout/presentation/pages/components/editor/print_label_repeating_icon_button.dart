import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PrintLabelRepeatingIconButton extends HookWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final VisualDensity? visualDensity;
  final EdgeInsetsGeometry? padding;
  final BoxConstraints? constraints;
  final Duration repeatInterval;

  const PrintLabelRepeatingIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.visualDensity,
    this.padding,
    this.constraints,
    required this.repeatInterval,
  });

  @override
  Widget build(BuildContext context) {
    final timerRef = useRef<Timer?>(null);
    final onPressedRef = useRef<VoidCallback?>(onPressed);
    onPressedRef.value = onPressed;
    final isEnabled = onPressed != null;

    void stopRepeating() {
      timerRef.value?.cancel();
      timerRef.value = null;
    }

    void startRepeating() {
      if (!isEnabled) return;
      stopRepeating();

      onPressedRef.value?.call();
      timerRef.value = Timer.periodic(repeatInterval, (_) {
        if (onPressedRef.value == null) {
          stopRepeating();
          return;
        }
        onPressedRef.value?.call();
      });
    }

    useEffect(() {
      if (!isEnabled) {
        stopRepeating();
      }
      return stopRepeating;
    }, [isEnabled, repeatInterval]);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPressStart: isEnabled ? (_) => startRepeating() : null,
      onLongPressEnd: (_) => stopRepeating(),
      onLongPressCancel: stopRepeating,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        visualDensity: visualDensity,
        padding: padding,
        constraints: constraints,
      ),
    );
  }
}
