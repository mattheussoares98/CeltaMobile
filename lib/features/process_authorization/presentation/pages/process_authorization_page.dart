import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProcessAuthorizationPage extends ConsumerWidget {
  final int enterpriseCode;
  const ProcessAuthorizationPage({super.key, required this.enterpriseCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseScaffold(
      isScrollable: false,
      refreshProvider: judgmentsStateControllerProvider,
      appBar: BaseAppBar(title: 'Autorização de processos'.hardcoded),
      body: AsyncValueWidget(
        value: ref.watch(judgmentsStateControllerProvider),
        tryAgain: () => ref.invalidate(judgmentsStateControllerProvider),
        data: (data) {
          return ResponsiveListFlow(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return DefaultText(item.toString());
            },
          );
        },
      ),
    );
  }
}
