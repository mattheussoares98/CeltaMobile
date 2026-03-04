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

class MyGridView extends ConsumerWidget {
  const MyGridView({
    super.key,
    required this.spacing,
    required this.crossAxisCount,
  });

  final double spacing;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(sortedModulesStateControllerProvider);
    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.all(spacing),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: spacing,
              crossAxisSpacing: spacing,
              mainAxisExtent: 90,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final module = data.list[index];
                return StaticModuleItem(key: ValueKey(module), module: module);
              },
              childCount: data.list.length,
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
  }
}

class StaticModuleItem extends StatelessWidget {
  const StaticModuleItem({super.key, required this.module});

  final Modules module;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(child: ButtonsByModuleItems.buttonByModule[module]!);
  }
}
