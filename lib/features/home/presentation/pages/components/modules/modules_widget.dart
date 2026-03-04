import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../controllers/controllers.dart';
import '../components.dart';

class ModulesWidget extends StatelessWidget {
  const ModulesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // PERFORMANCE: Use sizeOf for optimized rebuilds on screen width change only.
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < Breakpoint.tablet;
    const double spacing = Sizes.p4;

    if (isMobile) {
      return const MyGridView(spacing: spacing, crossAxisCount: 2);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 700
            ? 4
            : (constraints.maxWidth / 160).floor().clamp(1, 4);
        return MyGridView(spacing: spacing, crossAxisCount: crossAxisCount);
      },
    );
  }
}

class MyGridView extends StatelessWidget {
  const MyGridView({
    super.key,
    required this.spacing,
    required this.crossAxisCount,
  });

  final double spacing;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    // PERFORMANCE: Using a CustomScrollView with a SliverGrid instead of a
    // GridView with shrinkWrap. shrinkWrap is expensive as it forces
    // a redundant layout pass to calculate total height.
    return RepaintBoundary(
      child: Consumer(
        builder: (context, ref, child) {
          final data = ref.watch(sortedModulesStateControllerProvider);

          return CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.all(spacing),
                sliver: SliverGrid(
                  // PERFORMANCE: Explicitly providing a stable grid delegate
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: spacing,
                    crossAxisSpacing: spacing,
                    mainAxisExtent: 90,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final module = data.list[index];
                      return RepaintBoundary(
                        child: ButtonsByModuleItems.buttonByModule[module]!,
                      );
                    },
                    childCount: data.list.length,
                    // PERFORMANCE: findChildIndexCallback is essential for
                    // maintaining the identity of already built items.
                    findChildIndexCallback: (Key key) {
                      if (key is ValueKey<Modules>) {
                        return data.indexMap[key.value];
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
