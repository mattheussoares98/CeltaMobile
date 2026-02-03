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

    final enterprisesAsync = ref.watch(enterprisesStateControllerProvider());

    return Scaffold(
      drawer: const CompleteDrawer(),
      appBar: AppBar(
        leadingWidth: 40,
        title: AsyncValueWidget(
          value: enterprisesAsync,
          tryAgain: () => ref.invalidate(validatedUserSessionProvider),
          errorMaxLines: 2,
          data: (enterprises) {
            return SelectEnterpriseDropDown(enterprises: enterprises);
          },
        ),
      ),

      body:
          enterprisesAsync.hasValue &&
              !enterprisesAsync.isLoading &&
              !enterprisesAsync.hasError
          ? AsyncValueWidget(
              value: ref.watch(
                enabledModulesByEnterpriseNameStateControllerProvider(
                  selectedEnterpriseStateControllerProvider.name!,
                ),
              ),
              tryAgain: () => ref.invalidate(
                enabledModulesByEnterpriseNameStateControllerProvider(
                  selectedEnterpriseStateControllerProvider.name!,
                ),
              ),
              data: (_) => const ModulesWidget(),
            )
          : null,
    );
  }
}
