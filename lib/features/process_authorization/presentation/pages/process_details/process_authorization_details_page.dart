import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProcessAuthorizationDetailsPage extends ConsumerWidget {
  final int processCode;
  const ProcessAuthorizationDetailsPage({super.key, required this.processCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = judgmentDetailsStateControllerProvider(processCode);
    return BaseScaffold(
      refreshProvider: provider,
      isScrollable: true,
      appBar: BaseAppBar(
        title: 'Detalhes do processo'.hardcoded,
        showSelectedEnterprise: true,
      ),
      body: AsyncValueWidget(
        value: ref.watch(provider),
        tryAgain: () => ref.invalidate(provider),
        data: (data) {
          return Column(
            crossAxisAlignment: .stretch,
            children: [
              Consumer(
                builder: (_, ref, _) {
                  final defendants = data.defendants
                      ?.cast<BSFSaleRequestDefendantEntity>();
                  //TODO convert it correctly

                  if (defendants?.isEmpty ?? true) {
                    return const SizedBox.shrink();
                  }
                  final saleRequest = defendants!.first.saleRequest;

                  final controller =
                      processAuthorizationErrorsStateControllerProvider(
                        customerCode: saleRequest.customer!.code!,
                        enterpriseCode: saleRequest.enterprise!.code!,
                        saleRequestCode: saleRequest.code!,
                      );
                  return Column(
                    children: [
                      PrimaryButton(
                        isLoading: ref.watch(controller).isLoading,
                        onPressed: () => ref.invalidate(controller),
                        text: 'tenta aqui poxa'.hardcoded,
                      ),
                      Consumer(
                        builder: (_, ref, _) {
                          final data = ref.watch(controller);
                          return BaseText(data.toString());
                        },
                      ),
                      const Divider(),
                    ],
                  );
                },
              ),
              BaseText(data.toString()),
            ],
          );
        },
      ),
    );
  }
}
