import 'dart:async';

import 'package:flutter/material.dart';

class PrintLabelRepeatingIconButton extends StatefulWidget {
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
    this.repeatInterval = const Duration(milliseconds: 75),
  });

  @override
  State<PrintLabelRepeatingIconButton> createState() =>
      _PrintLabelRepeatingIconButtonState();
}

class _PrintLabelRepeatingIconButtonState
    extends State<PrintLabelRepeatingIconButton> {
  Timer? _timer;

  bool get _isEnabled => widget.onPressed != null;

  void _startRepeating() {
    if (!_isEnabled) return;
    _stopRepeating();

    widget.onPressed?.call();
    _timer = Timer.periodic(widget.repeatInterval, (_) {
      if (!mounted || !_isEnabled) {
        _stopRepeating();
        return;
      }
      widget.onPressed?.call();
    });
  }

  void _stopRepeating() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stopRepeating();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PrintLabelRepeatingIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onPressed == null && oldWidget.onPressed != null) {
      _stopRepeating();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPressStart: _isEnabled ? (_) => _startRepeating() : null,
      onLongPressEnd: (_) => _stopRepeating(),
      onLongPressCancel: _stopRepeating,
      child: IconButton(
        onPressed: widget.onPressed,
        icon: widget.icon,
        visualDensity: widget.visualDensity,
        padding: widget.padding,
        constraints: widget.constraints,
      ),
    );
  }
}
