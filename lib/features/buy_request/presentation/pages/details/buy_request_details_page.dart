import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/buy_request/presentation/pages/components/components.dart';
import 'package:celta_inventario/features/buy_request/presentation/pages/details/components/components.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BuyRequestDetailsPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  final int buyRequestCode;
  const BuyRequestDetailsPage({
    super.key,
    required this.enterpriseCode,
    required this.buyRequestCode,
  });

  @override
  ConsumerState<BuyRequestDetailsPage> createState() =>
      _BuyRequestDetailsPageState();
}

class _BuyRequestDetailsPageState extends ConsumerState<BuyRequestDetailsPage> {
  static const _scrollToTopThreshold = 600.0;
  final _scrollController = ScrollController();
  final _showScrollToTopButton = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateScrollToTopButtonVisibility);
  }

  void _updateScrollToTopButtonVisibility() {
    final shouldShow = _scrollController.offset > _scrollToTopThreshold;
    if (_showScrollToTopButton.value != shouldShow) {
      _showScrollToTopButton.value = shouldShow;
    }
  }

  Future<void> _scrollToTop() async {
    if (!_scrollController.hasClients) return;

    await _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollToTopButtonVisibility);
    _scrollController.dispose();
    _showScrollToTopButton.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = buyRequestDetailsStateControllerProvider(
      widget.buyRequestCode,
    );
    final shallowBuyRequest = ref.watch(
      shallowBuyRequestStateControllerProvider(widget.enterpriseCode).select(
        (s) => s.value?.firstWhereOrNull(
          (buyRequest) => buyRequest.code == widget.buyRequestCode,
        ),
      ),
    );
    return BaseScaffold(
      isScrollable: false,
      refreshProvider: provider,
      appBar: BaseAppBar(
        title: (shallowBuyRequest?.personalizedCode?.isNotEmpty ?? false)
            ? context.l10n.purchaseOrderDetailsWithCode(
                shallowBuyRequest?.personalizedCode ?? '',
              )
            : context.l10n.details,
        selectedEnterpriseCode: widget.enterpriseCode,
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _showScrollToTopButton,
        builder: (context, shouldShow, child) {
          if (!shouldShow) return const SizedBox.shrink();

          return FloatingActionButton(
            tooltip: context.l10n.backToTop,
            onPressed: _scrollToTop,
            child: const PlatformIcon(
              cupertinoIcon: CupertinoIcons.arrow_up,
              materialIcon: Icons.arrow_upward,
            ),
          );
        },
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Consumer(
              builder: (_, ref, _) {
                final completeBuyRequest = ref.watch(provider).value;
                return SearchedBuyRequestItem(
                  buyRequest: completeBuyRequest ?? shallowBuyRequest!,
                );
              },
            ),
          ),
          BuyRequestProductsItems(buyRequestCode: widget.buyRequestCode),
          gapSliverH24,
        ],
      ),
    );
  }
}
