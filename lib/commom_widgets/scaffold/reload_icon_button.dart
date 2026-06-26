import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReloadIconButton extends StatefulWidget {
  final Future<void> Function()? onRefresh;
  const ReloadIconButton({super.key, required this.onRefresh});

  @override
  State<ReloadIconButton> createState() => _ReloadIconButtonState();
}

class _ReloadIconButtonState extends State<ReloadIconButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _isLoading
          ? null
          : () async {
              if (!mounted) return;
              setState(() {
                _isLoading = true;
              });
              _animationController.repeat();
              try {
                await widget.onRefresh?.call();
              } finally {
                if (mounted) {
                  await _animationController.forward(
                    from: _animationController.value,
                  );
                  if (mounted) {
                    _animationController.reset();
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }
              }
            },
      icon: SizedBox(
        width: 24,
        height: 24,
        child: RotationTransition(
          turns: _animationController,
          child: PlatformIcon(
            materialIcon: _isLoading ? Icons.refresh : Icons.refresh_outlined,
            cupertinoIcon: _isLoading
                ? CupertinoIcons.refresh
                : CupertinoIcons.refresh,
          ),
        ),
      ),
    );
  }
}
