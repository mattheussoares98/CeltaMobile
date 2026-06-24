import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/products_register/presentation/controllers/product_state_controller.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateProductPage extends StatelessWidget {
  final int enterpriseCode;
  final int productCode;
  const CreateProductPage({
    super.key,
    required this.enterpriseCode,
    required this.productCode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro de produtos'.hardcoded)),
      body: Consumer(
        builder: (_, ref, _) {
          final provider = productStateControllerProvider(
            enterpriseCode: enterpriseCode,
            productCode: productCode,
          );
          return ResponsiveScrollableWidget(
            child: AsyncValueWidget(
              value: ref.watch(provider),
              tryAgain: () => ref.invalidate(provider),
              data: (data) {
                if (data == null) {
                  return const SizedBox.shrink();
                }
                return Text(data.toString());
              },
            ),
          );
        },
      ),
    );
  }
}
