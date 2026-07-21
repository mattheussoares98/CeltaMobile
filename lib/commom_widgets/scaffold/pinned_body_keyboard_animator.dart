part of './base_scaffold.dart';

class _PinnedBodyKeyboardAnimator extends StatefulWidget {
  final Widget child;
  const _PinnedBodyKeyboardAnimator({required this.child});

  @override
  State<_PinnedBodyKeyboardAnimator> createState() =>
      _PinnedBodyKeyboardAnimatorState();
}

class _PinnedBodyKeyboardAnimatorState
    extends State<_PinnedBodyKeyboardAnimator>
    with WidgetsBindingObserver {
  final _focusScopeNode = FocusScopeNode();
  double _lastBottomInset = 0;
  bool _isClosingOrClosed = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _focusScopeNode.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (!mounted) return;
    final view = View.of(context);
    final currentBottomInset = view.viewInsets.bottom / view.devicePixelRatio;

    final isClosed = currentBottomInset <= 1.0;
    final isClosing = currentBottomInset < (_lastBottomInset - 1.0);
    final isOpening = currentBottomInset > (_lastBottomInset + 1.0);

    bool newIsClosingOrClosed = _isClosingOrClosed;

    // If an input inside pinnedBody (e.g. SearchProductField) is focused, keep pinnedBody visible
    if (_focusScopeNode.hasFocus || isClosed || isClosing) {
      newIsClosingOrClosed = true;
    } else if (isOpening) {
      newIsClosingOrClosed = false;
    }

    _lastBottomInset = currentBottomInset;

    if (_isClosingOrClosed != newIsClosingOrClosed) {
      setState(() {
        _isClosingOrClosed = newIsClosingOrClosed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.fastOutSlowIn,
      child: _isClosingOrClosed
          ? FocusScope(
              node: _focusScopeNode,
              child: ColoredBox(
                color: context.theme.scaffoldBackgroundColor,
                child: widget.child,
              ),
            )
          : const SizedBox(width: double.infinity, height: 0),
    );
  }
}
