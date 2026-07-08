import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/process_authorization/presentation/pages/process_details/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProcessAuthorizationSaleRequestDiscountsPage
    extends ConsumerStatefulWidget {
  final int processCode;
  const ProcessAuthorizationSaleRequestDiscountsPage({
    super.key,
    required this.processCode,
  });

  @override
  ConsumerState<ProcessAuthorizationSaleRequestDiscountsPage> createState() =>
      _ProcessAuthorizationSaleRequestDiscountsPageState();
}

class _ProcessAuthorizationSaleRequestDiscountsPageState
    extends ConsumerState<ProcessAuthorizationSaleRequestDiscountsPage> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    super.dispose();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        processAuthorizationSaleRequestErrorsStateControllerProvider(
          processCode: widget.processCode,
          errorType: SaleRequestErrorType.discount,
        );
    return BaseScaffold(
      refreshProvider: provider,
      isScrollable: false,
      usePadding: false,
      appBar: BaseAppBar(
        title: 'Análise de descontos no pedido'.hardcoded,
        showSelectedEnterprise: true,
      ),
      body: AsyncValueWidget(
        value: ref.watch(provider),
        tryAgain: () => ref.invalidate(provider),
        data: (data) {
          final discount = data.discount;
          final items = discount?.items ?? [];

          if (items.isEmpty) {
            return EmptyPlaceholderWidget(
              message: 'Nenhum desconto encontrado'.hardcoded,
            );
          }

          return DiscountAnalysisTable(refreshProvider: provider, items: items);
        },
      ),
    );
  }
}
