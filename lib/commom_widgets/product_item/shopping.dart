import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/constants.dart';
import '../commom_widgets.dart';

class Shopping extends StatelessWidget {
  //TODO remove riverpod from these pages that is not using
  const Shopping({super.key, required this.widget});

  final ProductInfoModal widget;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: Sizes.p8),
            child: DefaultTitle(title: 'Últimas compras'.hardcoded),
          ),
        ),
        SliverList.builder(
          itemCount: widget.product.LastBuyEntrances?.length ?? 0,
          itemBuilder: (_, index) {
            final buy = widget.product.LastBuyEntrances![index];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                TitleAndSubTitle(
                  title: 'Fornecedor'.hardcoded,
                  subTitle: buy.Supplier,
                ),
                TitleAndSubTitle(
                  title: 'Data'.hardcoded,
                  subTitle: DateFormat(
                    'dd/MM/yyyy HH:mm',
                  ).format(DateTime.parse(buy.EntranceDate)),
                ),
                TitleAndSubTitle(
                  title: 'CFOP'.hardcoded,
                  subTitle: buy.FiscalCode,
                ),
                TitleAndSubTitle(
                  title: 'Número'.hardcoded,
                  subTitle: buy.Number,
                ),
                TitleAndSubTitle(
                  title: 'Embalagem'.hardcoded,
                  subTitle: buy.Packing,
                ),
                TitleAndSubTitle(
                  title: 'Quantidade'.hardcoded,
                  subTitle: buy.Quantity.toString().toBrazilianNumber(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
