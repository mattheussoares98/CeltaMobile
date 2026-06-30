import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrintAndGeneratePdfActions extends ConsumerWidget {
  final int enterpriseCode;
  final bool isInserting;
  const PrintAndGeneratePdfActions({
    super.key,
    required this.enterpriseCode,
    required this.isInserting,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!isInserting) return const SizedBox.shrink();

    final now = DateTime.now();
    Future<void> searchTodaySaleRequests() async {
      ref
          .read(saleRequestsStateControllerProvider(enterpriseCode).notifier)
          .load(
            startDateHourOfCreation: DateTime(now.year, now.month, now.day),
          );
    }

    void onTap() {
      showModalPage(
        _TodaySaleRequests(
          enterpriseCode: enterpriseCode,
          searchTodaySaleRequests: searchTodaySaleRequests,
        ),
        context,
      );
    }

    return Row(
      children: [
        IconButton(
          onPressed: onTap,
          icon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.printer,
            materialIcon: Icons.print,
          ),
        ),
        IconButton(
          onPressed: onTap,
          icon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.doc_text_search,
            materialIcon: Icons.picture_as_pdf_rounded,
          ),
        ),
      ],
    );
  }
}

class _TodaySaleRequests extends StatefulWidget {
  final int enterpriseCode;
  final VoidCallback searchTodaySaleRequests;
  const _TodaySaleRequests({
    required this.enterpriseCode,
    required this.searchTodaySaleRequests,
  });

  @override
  State<_TodaySaleRequests> createState() => _TodaySaleRequestsState();
}

class _TodaySaleRequestsState extends State<_TodaySaleRequests> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        widget.searchTodaySaleRequests();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      isScrollable: false,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: .center,
              children: [
                Flexible(
                  child: DefaultText.headline(
                    'Pedidos de hoje'.hardcoded,
                    textAlign: TextAlign.center,
                  ),
                ),
                gapW12,
                IconButton(
                  icon: const PlatformIcon(
                    cupertinoIcon: CupertinoIcons.refresh,
                    materialIcon: Icons.refresh,
                  ),
                  onPressed: widget.searchTodaySaleRequests,
                ),
              ],
            ),
          ),
          gapSliverH8,
          Consumer(
            builder: (context, ref, _) {
              return AsyncValueWidget(
                isSliver: true,
                value: ref.watch(
                  saleRequestsStateControllerProvider(widget.enterpriseCode),
                ),
                tryAgain: null,
                data: (saleRequests) {
                  final totalRecords = saleRequests?.totalRecords ?? 0;
                  if (totalRecords == 0) {
                    return SliverToBoxAdapter(
                      child: Column(
                        children: [
                          DefaultText.error(
                            'Nenhum pedido encontrado'.hardcoded,
                          ),
                          PrimaryButton(
                            text: 'Pesquisar novamente'.hardcoded,
                            onPressed: widget.searchTodaySaleRequests,
                          ),
                        ],
                      ),
                    );
                  }

                  return ResponsiveListFlow(
                    isSliver: true,
                    maxItemWidth: double.infinity,
                    itemCount: totalRecords,
                    itemBuilder: (context, index) {
                      final item = saleRequests?.collection[index];
                      final args = SaleRequestArgs(
                        enterpriseCode: widget.enterpriseCode,
                        saleRequestId: item!.Id!,
                      );
                      return RequestSummaryWidget(
                        args: args,
                        showPrintAndPdfButtons: true,
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
