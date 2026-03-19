import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/resource/resource.dart';
import '../controllers/controllers.dart';
import 'components/components.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.observeLoading([
      canAccessResourceStateControllerProvider(
        BsRoutine.adjustSalePrice,
        BsResource.adjustSalePrice,
      ),
    ]);

    return Scaffold(
      drawer: const CompleteDrawer(),
      appBar: AppBar(leadingWidth: 40, title: const SelectEnterpriseDropDown()),

      body: OptimazedAsyncValueWidget(
        provider: homeInitializationControllerProvider,
        tryAgain: () => ref.invalidate(homeInitializationControllerProvider),
        child: const ModulesWidget(),
      ),
    );
  }
}
