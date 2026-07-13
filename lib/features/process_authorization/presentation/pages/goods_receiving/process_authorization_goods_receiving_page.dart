import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProcessAuthorizationGoodsReceivingPage extends ConsumerWidget {
  final int processCode;
  const ProcessAuthorizationGoodsReceivingPage({
    super.key,
    required this.processCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = processAuthorizationGoodsReceivingStateControllerProvider(
      processCode,
    );
    return BaseScaffold(
      refreshProvider: provider,
      appBar: BaseAppBar(title: 'Recebimento de mercadorias'.hardcoded),
      body: AsyncValueWidget(
        value: ref.watch(provider),
        tryAgain: () => ref.invalidate(provider),
        data: (data) {
          return Center(child: Text(data.toString()));
        },
      ),
    );
  }
}
