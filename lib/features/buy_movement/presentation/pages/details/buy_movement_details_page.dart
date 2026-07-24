import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/buy_movement/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/buy_movement/presentation/pages/components/components.dart';
import 'package:celta_inventario/features/buy_movement/presentation/pages/details/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BuyMovementDetailsPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  final int buyMovementCode;
  const BuyMovementDetailsPage({
    super.key,
    required this.enterpriseCode,
    required this.buyMovementCode,
  });

  @override
  ConsumerState<BuyMovementDetailsPage> createState() =>
      _BuyMovementDetailsPageState();
}

class _BuyMovementDetailsPageState
    extends ConsumerState<BuyMovementDetailsPage> {
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
    final provider = buyMovementDetailsStateControllerProvider(
      widget.buyMovementCode,
    );
    final shallowBuyMovement = ref.watch(
      shallowBuyMovementStateControllerProvider(widget.enterpriseCode).select(
        (s) => s.value?.firstWhereOrNull(
          (buyMovement) => buyMovement.code == widget.buyMovementCode,
        ),
      ),
    );
    return BaseScaffold(
      isScrollable: false,
      refreshProvider: provider,
      appBar: BaseAppBar(
        title: ((shallowBuyMovement?.documentNumber ?? 0) > 0)
            ? 'Detalhes da compra (${shallowBuyMovement?.documentNumber ?? ''})'
                  .hardcoded
            : 'Detalhes da compra'.hardcoded,
        selectedEnterpriseCode: widget.enterpriseCode,
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _showScrollToTopButton,
        builder: (context, shouldShow, child) {
          if (!shouldShow) return const SizedBox.shrink();

          return FloatingActionButton(
            tooltip: 'Voltar ao topo'.hardcoded,
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
                return SearchedBuyMovementItem(
                  buyMovement: completeBuyRequest ?? shallowBuyMovement!,
                );
              },
            ),
          ),
          BuyMovementProductsItems(buyMovementCode: widget.buyMovementCode),
          gapSliverH24,
        ],
      ),
    );
  }
}
