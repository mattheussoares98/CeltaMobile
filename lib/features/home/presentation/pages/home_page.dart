import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/enterprises/enterprises.dart';
import '../../../../core/presentation/controllers/resource/resource.dart';
import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../../commom_widgets/commom_widgets.dart';
import '../../../enterprises/presentation/controllers/controllers.dart';
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
      appBar: AppBar(
        leadingWidth: 40,
        title: RepaintBoundary(
          child: AsyncValueWidget(
            value: ref.watch(enterprisesStateControllerProvider()),
            tryAgain: null,
            errorMaxLines: 1,
            data: (enterprises) {
              return SelectEnterpriseDropDown(enterprises: enterprises);
            },
          ),
        ),
      ),

      body: RepaintBoundary(
        child: OptimazedAsyncValueWidget(
          provider: enterprisesStateControllerProvider(),
          tryAgain: () => ref.invalidate(enterprisesStateControllerProvider()),
          child: Consumer(
            builder: (_, ref, _) {
              final enterpriseName = ref.watch(
                userSessionProvider.select((s) => s.value?.enterprise?.name),
              );

              if (enterpriseName == null) {
                return const SizedBox.shrink();
              }

              return OptimazedAsyncValueWidget(
                provider: enabledModulesByEnterpriseNameStateControllerProvider(
                  enterpriseName,
                ),
                tryAgain: () => ref.invalidate(
                  enabledModulesByEnterpriseNameStateControllerProvider(
                    enterpriseName,
                  ),
                ),
                child: const ModulesWidget(),
              );
            },
          ),
        ),
      ),
    );
  }
}
