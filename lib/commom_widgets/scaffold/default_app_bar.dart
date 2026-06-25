import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DefaultAppBar({
    super.key,
    this.showLeading = true,
    this.leading,
    this.title = '',
    this.titleFontWeight,
    this.titleStyle,
    this.centerTitle = false,
    this.actions,
    this.showSelectedEnterprise = false,
    this.subtitle,
    this.actionsPadding,
  });
  final bool showLeading;
  final Widget? leading;
  final String title;
  final FontWeight? titleFontWeight;
  final TextStyle? titleStyle;
  final bool centerTitle;
  final List<Widget>? actions;
  final bool showSelectedEnterprise;
  final Widget? subtitle;
  final EdgeInsetsGeometry? actionsPadding;

  DefaultAppBar copyWith({
    bool? showLeading,
    Widget? leading,
    String? title,
    FontWeight? titleFontWeight,
    TextStyle? titleStyle,
    bool? centerTitle,
    List<Widget>? actions,
    bool? showSelectedEnterprise,
    Widget? subtitle,
  }) {
    return DefaultAppBar(
      key: key,
      showLeading: showLeading ?? this.showLeading,
      leading: leading ?? this.leading,
      title: title ?? this.title,
      titleFontWeight: titleFontWeight ?? this.titleFontWeight,
      titleStyle: titleStyle ?? this.titleStyle,
      centerTitle: centerTitle ?? this.centerTitle,
      actions: actions ?? this.actions,
      showSelectedEnterprise:
          showSelectedEnterprise ?? this.showSelectedEnterprise,
      subtitle: subtitle ?? this.subtitle,
    );
  }

  @override
  Widget build(BuildContext context) {
    // AppBar padding
    final double horizontalPadding = ScreenUtil.I.horizontalSpace;
    // AppBar leading height and width
    const double leadingSize = 40;
    // The maximum width of the AppBar leading
    final double leadingWidth = showLeading
        ? horizontalPadding + leadingSize
        : 0;
    // Space between Leading and title
    final double titleSpacing = showLeading ? 8 : horizontalPadding;

    Widget? leadingWidget;
    Widget? appBarTitleWidget;

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

    if (title.isNotEmpty || showSelectedEnterprise || subtitle != null) {
      final centerTitle = !PlatformUtil.isAndroid;
      final crossAxisAlignment = centerTitle
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start;

      appBarTitleWidget = Column(
        mainAxisSize: .min,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          if (title.isNotEmpty) ...[DefaultText.titleLarge(title)],
          if (showSelectedEnterprise)
            const CorrespondentEnterpriseByEnterpriseCode(),
          if (subtitle != null)
            Align(alignment: Alignment.centerLeft, child: subtitle),
        ],
      );
    }

    if (context.isCupertino) {
      if (subtitle != null) {
        return Container(
          height:
              preferredSize.height +
              MediaQuery.paddingOf(context).top +
              (actionsPadding?.vertical ?? 0),
          padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            border: const Border(bottom: BorderSide(color: Colors.transparent)),
          ),
          child: Row(
            children: [
              if (showLeading)
                SizedBox(width: leadingWidth, child: leadingWidget),
              Expanded(child: Center(child: appBarTitleWidget)),
              if (actions != null)
                Padding(
                  padding: actionsPadding ?? EdgeInsets.zero,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: actions!,
                  ),
                )
              else if (showLeading)
                SizedBox(width: leadingWidth),
            ],
          ),
        );
      }

      return CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        transitionBetweenRoutes: false,
        leading: leadingWidget,
        middle: appBarTitleWidget,
        trailing: actions != null
            ? Padding(
                padding: actionsPadding ?? EdgeInsets.zero,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions!,
                ),
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
      title: appBarTitleWidget,
      centerTitle: centerTitle,
      actions: actions,
      actionsPadding: actionsPadding,
      toolbarHeight: preferredSize.height + MediaQuery.paddingOf(context).top,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(subtitle != null ? 64 : 50.0);
}
