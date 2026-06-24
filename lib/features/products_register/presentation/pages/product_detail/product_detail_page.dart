import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/app_sizes.dart';
import 'package:celta_inventario/features/products_register/domain/entities/entities.dart';
import 'package:celta_inventario/features/products_register/presentation/controllers/product_detail_controller.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailPage extends StatefulWidget {
  final int enterpriseCode;
  final int productCode;

  const ProductDetailPage({
    super.key,
    required this.enterpriseCode,
    required this.productCode,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalhes do produto'.hardcoded)),
      body: Consumer(
        builder: (_, ref, _) {
          final provider = productDetailControllerProvider(
            enterpriseCode: widget.enterpriseCode,
            productCode: widget.productCode,
          );

          return AsyncValueWidget(
            value: ref.watch(provider),
            tryAgain: () => ref.invalidate(provider),
            data: (_) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(Sizes.p16),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Pesquisar propriedade...'.hardcoded,
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                Expanded(
                  child: _SearchResultList(
                    results: ref
                        .read(provider.notifier)
                        .search(_searchController.text),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SearchResultList extends StatelessWidget {
  final List<BsfProductPropertyEntity> results;

  const _SearchResultList({required this.results});

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return EmptyPlaceholderWidget(message: 'Implement it here'.hardcoded);
    }

    return ListView.separated(
      itemCount: results.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (_, index) {
        final property = results[index];
        return ListTile(
          title: Text(
            property.labelPt,
            style: context.theme.textTheme.bodySmall,
          ),
          subtitle: Text(
            property.displayValue,
            style: context.theme.textTheme.bodyMedium,
          ),
        );
      },
    );
  }
}
