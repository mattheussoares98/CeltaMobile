import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/search_sale_request/components/components.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchSaleRequestPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  const SearchSaleRequestPage({super.key, required this.enterpriseCode});

  @override
  ConsumerState<SearchSaleRequestPage> createState() =>
      _SearchSaleRequestPageState();
}

class _SearchSaleRequestPageState extends ConsumerState<SearchSaleRequestPage> {
  static final now = DateTime.now();
  final _startController = TextEditingController(text: now.formatDate());
  final filtersFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _startController.dispose();
    super.dispose();
  }

  void onChangePage(int page) {
    if (_startController.text.toDateTime() == null) {
      return;
    }

    ref
        .read(
          saleRequestsStateControllerProvider(widget.enterpriseCode).notifier,
        )
        .load(
          startDateHourOfCreation: _startController.text.toDateTime() ?? now,
          actualPage: page,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      isScrollable: false,
      appBar: BaseAppBar(
        title: context.l10n.orderSearch,
        selectedEnterpriseCode: widget.enterpriseCode,
      ),
      body: Column(
        children: [
          SaleRequestFilters(
            filtersFormKey: filtersFormKey,
            startController: _startController,
            enterpriseCode: widget.enterpriseCode,
          ),
          BasePaginationButtons(
            enterpriseCode: widget.enterpriseCode,
            onChangePage: onChangePage,
            provider: saleRequestsStateControllerProvider(
              widget.enterpriseCode,
            ),
          ),
          RequestsItems(enterpriseCode: widget.enterpriseCode),
        ],
      ),
    );
  }
}
