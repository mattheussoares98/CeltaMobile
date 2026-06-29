import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/home/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/home/presentation/pages/components/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseScaffold(
      isScrollable: false,
      usePadding: true,
      drawer: const CompleteDrawer(),
      appBar: BaseAppBar(
        showLeading: true,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const PlatformIcon(
              materialIcon: Icons.menu,
              cupertinoIcon: CupertinoIcons.bars,
            ),
          ),
        ),
        titleWidget: const SelectEnterpriseDropDown(),
      ),
      body: OptimazedAsyncValueWidget(
        provider: homeInitializationControllerProvider,
        tryAgain: () =>
            ref.read(homeInitializationControllerProvider.notifier).refresh(),
        child: const ModulesWidget(),
      ),
    );
  }
}
