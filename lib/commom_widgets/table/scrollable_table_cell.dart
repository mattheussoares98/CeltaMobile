part of 'scrollable_table.dart';

class _ScrollableTableCell extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final Color? backgroundColor;

  const _ScrollableTableCell({
    required this.child,
    required this.width,
    required this.height,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          bottom: BorderSide(color: context.theme.dividerColor, width: 0.5),
          right: BorderSide(color: context.theme.dividerColor, width: 0.07),
        ),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: child,
    );
  }
}
