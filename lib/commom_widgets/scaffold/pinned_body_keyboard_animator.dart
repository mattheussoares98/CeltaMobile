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
  bool _isClosingOrClosed = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FocusManager.instance.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    FocusManager.instance.removeListener(_handleFocusChange);
    WidgetsBinding.instance.removeObserver(this);
    _focusScopeNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!mounted) return;
    _updateVisibility();
  }

  @override
  void didChangeMetrics() {
    if (!mounted) return;
    _updateVisibility();
  }

  void _updateVisibility() {
    final view = View.of(context);
    final currentBottomInset = view.viewInsets.bottom / view.devicePixelRatio;
    final isKeyboardOpen = currentBottomInset > 1.0;
    // Show pinned body if keyboard is closed OR if focus is inside pinned body
    final shouldShow = !isKeyboardOpen || _focusScopeNode.hasFocus;
    if (_isClosingOrClosed != shouldShow) {
      setState(() {
        _isClosingOrClosed = shouldShow;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.fastOutSlowIn,
      child: FocusScope(
        node: _focusScopeNode,
        child: ColoredBox(
          color: context.theme.scaffoldBackgroundColor,
          child: Visibility(
            visible: _isClosingOrClosed,
            maintainState: true,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
