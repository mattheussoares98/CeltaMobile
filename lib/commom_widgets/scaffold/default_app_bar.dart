import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BaseAppBar extends StatelessWidget {
  const BaseAppBar({
    super.key,
    this.showLeading = true,
    this.leading,
    required this.title,
    this.titleFontWeight,
    this.titleStyle,
    this.centerTitle = false,
    this.actions,
  });
  final bool showLeading;
  final Widget? leading;
  final String title;
  final FontWeight? titleFontWeight;
  final TextStyle? titleStyle;
  final bool centerTitle;
  final List<Widget>? actions;

  BaseAppBar copyWith({
    bool? showLeading,
    Widget? leading,
    String? title,
    FontWeight? titleFontWeight,
    TextStyle? titleStyle,
    bool? centerTitle,
    List<Widget>? actions,
  }) {
    return BaseAppBar(
      key: key,
      showLeading: showLeading ?? this.showLeading,
      leading: leading ?? this.leading,
      title: title ?? this.title,
      titleFontWeight: titleFontWeight ?? this.titleFontWeight,
      titleStyle: titleStyle ?? this.titleStyle,
      centerTitle: centerTitle ?? this.centerTitle,
      actions: actions ?? this.actions,
    );
  }

  @override
  Widget build(BuildContext context) {
    // AppBar padding
    final double horizontalPadding = ScreenUtil.I.horizontalSpace;
    // AppBar leading height and width
    const double leadingSize = 25;
    // The maximum width of the AppBar leading
    final double leadingWidth = showLeading
        ? horizontalPadding + leadingSize
        : 0;
    // Space between Leading and title
    final double titleSpacing = showLeading ? 8 : horizontalPadding;

    Widget? leadingWidget;
    Widget? titleWidget;

    if (showLeading) {
      leadingWidget =
          leading ??
          IconButton(
            onPressed: context.pop,
            icon: PlatformIcon(
              materialIcon: Icons.arrow_back,
              cupertinoIcon: CupertinoIcons.back,
              size: 20,
              color: context.colorScheme.onSurface,
            ),
          );
    }

    if (title.isNotEmpty) {
      titleWidget = DefaultText.bodyLarge(
        title,
        color: context.colorScheme.onSurface,
        fontWeight: titleFontWeight,
      );
    }

    if (context.isCupertino) {
      return CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        transitionBetweenRoutes: false,
        leading: leadingWidget,
        middle: titleWidget,
        trailing: actions != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions!,
              )
            : null,
        backgroundColor: context.colorScheme.surface,
        border: const Border(bottom: BorderSide(color: Colors.transparent)),
      );
    }

    return AppBar(
      automaticallyImplyLeading: false,
      leading: leadingWidget,
      leadingWidth: leadingWidth,
      titleSpacing: titleSpacing,
      title: titleWidget,
      centerTitle: centerTitle,
      actions: actions,
    );
  }
}
