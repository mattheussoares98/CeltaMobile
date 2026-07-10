import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/process_authorization/presentation/pages/components/components.dart';
import 'package:celta_inventario/features/process_authorization/presentation/pages/sale_request_discount/components/components.dart';
import 'package:celta_inventario/features/process_authorization/presentation/pages/vote/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PageType {
  discount,
  lucrativity;

  factory PageType.fromName(String value) {
    switch (value.toLowerCase()) {
      case 'discount':
        return PageType.discount;
      case 'lucrativity':
        return PageType.lucrativity;
      default:
        throw Exception('Invalid page type: $value');
    }
  }
}

class ProcessAuthorizationSaleRequestBasePage extends ConsumerStatefulWidget {
  final int processCode;
  final PageType pageType;
  const ProcessAuthorizationSaleRequestBasePage({
    super.key,
    required this.processCode,
    required this.pageType,
  });

  @override
  ConsumerState<ProcessAuthorizationSaleRequestBasePage> createState() =>
      _ProcessAuthorizationSaleRequestBasePageState();
}

class _ProcessAuthorizationSaleRequestBasePageState
    extends ConsumerState<ProcessAuthorizationSaleRequestBasePage> {
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
          errorType: widget.pageType == PageType.discount
              ? SaleRequestErrorType.discount
              : SaleRequestErrorType.lucrativity,
        );

    final personalizedCode = ref.watch(
      judgmentDetailsStateControllerProvider(widget.processCode).select(
        (s) => s.value?.defendants
            ?.cast<BSFSaleRequestDefendantEntity>()
            .firstOrNull
            ?.saleRequest
            .personalizedCode,
      ),
    );

    String title = widget.pageType == PageType.discount
        ? 'Análise de descontos'.hardcoded
        : 'Análise de lucratividade'.hardcoded;
    if (personalizedCode != null) {
      title = "$title ($personalizedCode)";
    }

    return BaseScaffold(
      refreshProvider: provider,
      isScrollable: false,
      usePadding: false,
      appBar: BaseAppBar(
        title: widget.pageType == PageType.discount
            ? 'Análise de descontos'.hardcoded
            : 'Análise de lucratividade'.hardcoded,
        subtitle: OpenSaleRequestDetailsPageButton(
          processCode: widget.processCode,
          title: 'Detalhes do pedido'.hardcoded,
        ),
        actions: [OpenVotePageButton(processCode: widget.processCode)],
      ),
      body: AsyncValueWidget(
        value: ref.watch(provider),
        tryAgain: () => ref.invalidate(provider),
        data: (data) {
          if (widget.pageType == PageType.discount) {
            final items = data.discount?.items ?? const [];
            if (items.isEmpty) {
              return EmptyPlaceholderWidget(
                message: 'Nenhum desconto encontrado'.hardcoded,
              );
            }
            return DiscountAnalysisTable(
              refreshProvider: provider,
              items: items,
            );
          } else {
            final items = data.lucrativity?.items ?? const [];
            if (items.isEmpty) {
              return EmptyPlaceholderWidget(
                message: 'Nenhuma lucratividade encontrada'.hardcoded,
              );
            }
            return LucrativityAnalysisTable(
              refreshProvider: provider,
              items: items,
            );
          }
        },
      ),
    );
  }
}
