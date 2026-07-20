import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShallowBuyRequestsPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  const ShallowBuyRequestsPage({super.key, required this.enterpriseCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShallowBuyRequestsPageState();
}

class _ShallowBuyRequestsPageState
    extends ConsumerState<ShallowBuyRequestsPage> {
  static final now = DateTime.now();
  DateTime selectedDate = now;
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(title: 'Consulta de pedidos de compras'.hardcoded),
      body: Column(
        children: [
          Expanded(
            child: PrimaryButton(
              text: selectedDate.formatDate(),
              onPressed: () async {
                final newDate = await GetNewDate.get(
                  minimumDate: now.subtract(const Duration(days: 365 * 5)),
                  maximumDate: now,
                  context: context,
                );

                if (newDate != null) {
                  setState(() {
                    selectedDate = newDate;
                  });
                }
              },
            ),
          ),
          Expanded(
            child: PrimaryTextButton(
              text: 'Pesquisar'.hardcoded,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
