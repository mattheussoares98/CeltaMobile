import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
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
      isScrollable: false,
      refreshProvider: provider,
      appBar: BaseAppBar(
        title: 'Detalhes do processo'.hardcoded,
        showSelectedEnterprise: true,
      ),
      body: AsyncValueWidget(
        value: ref.watch(provider),
        tryAgain: () => ref.invalidate(provider),
        data: (data) {
          return DefaultText(data.toString());
        },
      ),
    );
  }
}
