import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

import '../commom_widgets.dart';

class BaseScaffold extends StatelessWidget {
  const BaseScaffold({
    super.key,
    this.showAnnotatedRegion = false,
    this.onPopInvokedWithResult,
    this.resizeToAvoidBottomInset = false,
    this.appBar,
    this.refreshProvider,
    this.isScrollable = true,
    this.scrollPhysics,
    this.padding,
    this.usePadding = true,
    required this.body,
    this.bottomNavigationBar,
    this.observeScreenChanges = false,
    this.bottomNavigationItems,
    this.bottomNavigationIndex,
    this.onBottomNavigationTap,
    this.drawer,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  final bool showAnnotatedRegion;
  final void Function()? onPopInvokedWithResult;
  final bool? resizeToAvoidBottomInset;
  final Widget? appBar;
  final ProviderBase<AsyncValue<dynamic>>? refreshProvider;
  final bool isScrollable;
  final ScrollPhysics? scrollPhysics;
  final EdgeInsets? padding;

  final bool usePadding;
  final Widget body;
  final Widget? bottomNavigationBar;
  final bool observeScreenChanges;
  final List<DefaultBottomNavigationBarItem>? bottomNavigationItems;
  final int? bottomNavigationIndex;
  final ValueChanged<int>? onBottomNavigationTap;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  @override
  Widget build(BuildContext context) {
    if (observeScreenChanges) {
      return Consumer(
        builder: (context, ref, child) {
          ref.watch(screenObserverProvider);
          return _BaseScaffold(this);
        },
      );
    }

    return _BaseScaffold(this);
  }
}

class _BaseScaffold extends StatelessWidget {
  const _BaseScaffold(this.params);
  final BaseScaffold params;

  EdgeInsets _getHorizontalPadding() => EdgeInsets.symmetric(
    horizontal: ScreenUtil.I.getResponsiveValue(
      base: 24,
      screens: {
        {ScreenType.largeTablet}: 22.widthPart(),
        {ScreenType.desktop}: kIsWeb ? 32.5.widthPart() : 27.widthPart(),
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    Widget newChild = params.body;

    Widget? finalAppBar = params.appBar;

    if (params.refreshProvider != null &&
        (PlatformUtil.isWeb || PlatformUtil.isDesktop)) {
      if (finalAppBar is DefaultAppBar) {
        final refreshAction = ReloadIconButton(
          refreshProvider: params.refreshProvider,
        );
        finalAppBar = finalAppBar.copyWith(
          actions: [
            ...?finalAppBar.actions,
            refreshAction,
          ].map((e) => FittedBox(child: e)).toList(),
        );
      }
    }

    final effectivePadding = params.usePadding
        ? params.padding ??
              (params.observeScreenChanges
                  ? _getHorizontalPadding()
                  : ScreenUtil.I.pagePadding().copyWith(
                      bottom: params.bottomNavigationBar == null ? null : 0,
                    ))
        : EdgeInsets.zero;

    if (params.isScrollable) {
      newChild = SingleChildScrollView(
        padding: effectivePadding,
        physics: params.scrollPhysics,
        child: params.body,
      );
    } else {
      newChild = Padding(padding: effectivePadding, child: params.body);
    }

    if (params.refreshProvider != null) {
      newChild = Consumer(
        builder: (context, ref, child) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(params.refreshProvider!);
              try {
                await ref.read((params.refreshProvider! as dynamic).future);
              } catch (_) {}
            },
            backgroundColor: context.theme.colorScheme.surface,
            strokeWidth: 2,
            edgeOffset: 100,
            child: child!,
          );
        },
        child: newChild,
      );
    }

    PreferredSizeWidget? appBarWidget;
    if (finalAppBar != null) {
      if (finalAppBar is PreferredSizeWidget) {
        appBarWidget = finalAppBar;
      } else {
        appBarWidget = PreferredSize(
          preferredSize: const Size(double.maxFinite, 50),
          child: finalAppBar,
        );
      }
    }

    Widget? bottomNavigationWidget = params.bottomNavigationBar;
    if (bottomNavigationWidget == null &&
        params.bottomNavigationItems != null &&
        params.bottomNavigationIndex != null &&
        params.onBottomNavigationTap != null) {
      bottomNavigationWidget = DefaultBottomNavigationBar(
        items: params.bottomNavigationItems!,
        currentIndex: params.bottomNavigationIndex!,
        onTap: params.onBottomNavigationTap!,
      );
    }

    Widget scaffold;

    if (context.isCupertino && params.drawer == null) {
      const cupertinoTabBarHeight = 49.0;
      var cupertinoBody = bottomNavigationWidget != null
          ? Padding(
              padding: EdgeInsets.only(
                bottom:
                    (cupertinoTabBarHeight +
                        MediaQuery.paddingOf(context).bottom) +
                    Sizes.p8,
              ),
              child: newChild,
            )
          : newChild;

      if (finalAppBar != null) {
        cupertinoBody = Column(
          children: [
            finalAppBar,
            Expanded(child: cupertinoBody),
          ],
        );
      }

      scaffold = CupertinoPageScaffold(
        resizeToAvoidBottomInset: params.resizeToAvoidBottomInset ?? true,
        child: SafeArea(
          bottom: bottomNavigationWidget == null,
          child: cupertinoBody,
        ),
      );

      if (bottomNavigationWidget != null) {
        scaffold = Stack(
          children: [
            scaffold,
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(top: false, child: bottomNavigationWidget),
            ),
          ],
        );
      }

      if (params.floatingActionButton != null) {
        scaffold = Stack(
          children: [
            scaffold,
            Positioned(
              right: 16.0,
              bottom: bottomNavigationWidget != null
                  ? 49.0 + 16.0 + MediaQuery.paddingOf(context).bottom
                  : 16.0 + MediaQuery.paddingOf(context).bottom,
              child: params.floatingActionButton!,
            ),
          ],
        );
      }

      scaffold = Material(color: Colors.transparent, child: scaffold);
    } else {
      scaffold = Scaffold(
        resizeToAvoidBottomInset: params.resizeToAvoidBottomInset,
        appBar: appBarWidget,
        body: SafeArea(child: newChild),
        bottomNavigationBar: bottomNavigationWidget,
        drawer: params.drawer,
        floatingActionButton: params.floatingActionButton,
        floatingActionButtonLocation: params.floatingActionButtonLocation,
      );
    }

    if (params.onPopInvokedWithResult != null) {
      scaffold = PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            return;
          }
          params.onPopInvokedWithResult?.call();
        },
        child: scaffold,
      );
    }

    if (params.showAnnotatedRegion) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: context.systemOverlayStyle,
        child: scaffold,
      );
    }

    return scaffold;
  }
}
