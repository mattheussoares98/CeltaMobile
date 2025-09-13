import '/constants/breakpoints.dart';
import 'package:flutter/material.dart';
import '/constants/app_sizes.dart';
import 'commom_widgets.dart';

/// Scrollable widget that shows a responsive card with a given child widget.
/// Useful for displaying forms and other widgets that need to be scrollable.
class ResponsiveScrollableWidget extends StatelessWidget {
  final bool? centralize;
  final double? maxContentWidth;
  const ResponsiveScrollableWidget({
    super.key,
    required this.child,
    this.centralize,
    this.maxContentWidth,
  });
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SingleChildScrollView(
      child: SizedBox(
        height: centralize == true ? mediaQuery.size.height : null,
        width: centralize == true ? mediaQuery.size.width : null,
        child: ResponsiveCenter(
          maxContentWidth: maxContentWidth ?? Breakpoint.tablet,
          child: Padding(padding: const EdgeInsets.all(Sizes.p8), child: child),
        ),
      ),
    );
  }
}
