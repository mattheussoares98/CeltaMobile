import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../utils/utils.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class SearchSaleRequestPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  const SearchSaleRequestPage({super.key, required this.enterpriseCode});

  @override
  ConsumerState<SearchSaleRequestPage> createState() =>
      _SearchSaleRequestPageState();
}

class _SearchSaleRequestPageState extends ConsumerState<SearchSaleRequestPage> {
  static final now = DateTime.now();
  final _startController = TextEditingController(
    text: DateFormat('dd/MM/yyyy').format(now),
  );
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
    return Scaffold(
      appBar: AppBar(title: Text('Busca de pedidos'.hardcoded)),
      body: Column(
        children: [
          SaleRequestFilters(
            enterpriseCode: widget.enterpriseCode,
            filtersFormKey: filtersFormKey,
            startController: _startController,
          ),
          DefaultPaginationButtons(
            paginationResults: ref.watch(
              saleRequestsStateControllerProvider(
                widget.enterpriseCode,
              ).select((s) => s.value),
            ),
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
