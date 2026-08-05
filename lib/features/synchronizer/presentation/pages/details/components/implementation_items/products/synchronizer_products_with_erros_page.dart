import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/presentation/pages/components/components.dart';
import 'package:celta_inventario/features/synchronizer/presentation/pages/details/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SynchronizerProductsWithErrosPage extends ConsumerStatefulWidget {
  const SynchronizerProductsWithErrosPage({super.key, required this.items});
  final List<BSFProductWithErrorSynchronizerErrorGroupEntity> items;

  @override
  ConsumerState<SynchronizerProductsWithErrosPage> createState() =>
      _SynchronizerProductsWithErrosPageState();
}

class _SynchronizerProductsWithErrosPageState
    extends ConsumerState<SynchronizerProductsWithErrosPage> {
  int currentIndex = 0; //TODO create a separated controller for this

  @override
  Widget build(BuildContext context) {
    //TODO enable to select the products and make some actions
    return BaseScaffold(
      isScrollable: false,
      usePadding: false,
      bottomNavigationBar: BaseBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) => setState(() {
          currentIndex = value;
        }),
        items: BSFProductWithErrorType.values.map((type) {
          final group = widget.items.firstWhereOrNull((e) => e.type == type);
          final quantity = group?.errors.length ?? 0;

          final IconData materialIcon;
          final IconData cupertinoIcon;

          switch (type) {
            case BSFProductWithErrorType.error:
              materialIcon = Icons.error_outline;
              cupertinoIcon = CupertinoIcons.exclamationmark_circle;
            case BSFProductWithErrorType.markedToSendAgain:
              materialIcon = Icons.sync;
              cupertinoIcon = CupertinoIcons.refresh;
            case BSFProductWithErrorType.markedToIgnoreError:
              materialIcon = Icons.visibility_off_outlined;
              cupertinoIcon = CupertinoIcons.eye_slash;
          }

          final String label = switch (type) {
            BSFProductWithErrorType.error => 'Erro'.hardcoded,
            BSFProductWithErrorType.markedToSendAgain => 'Reenviar'.hardcoded,
            BSFProductWithErrorType.markedToIgnoreError =>
              'Ignorados'.hardcoded,
          };

          return BaseBottomNavigationBarItem(
            label: label,
            platformIcon: PlatformIcon(
              materialIcon: materialIcon,
              cupertinoIcon: cupertinoIcon,
            ),
            badgeLabel: quantity.toString(),
          );
        }).toList(),
      ),
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: currentIndex,
              children: BSFProductWithErrorType.values.map((type) {
                final group = widget.items.firstWhereOrNull(
                  (e) => e.type == type,
                );
                final errors = group?.errors ?? const [];

                if (errors.isEmpty) return const SynchronizerEmptyErrors();

                final groupedErrors = groupBy(
                  errors,
                  (e) => e.enterprisePersonalizedCode,
                );
                final keys = groupedErrors.keys.toList();

                return ResponsiveListFlow(
                  itemCount: keys.length,
                  padding: const EdgeInsets.all(Sizes.p8),
                  itemBuilder: (context, index) {
                    final code = keys[index];
                    final enterpriseErrors = groupedErrors[code] ?? [];
                    final fantasyName =
                        enterpriseErrors.firstOrNull?.enterpriseFantasyName ??
                        '';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: Sizes.p8),
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        title: BaseRichText(
                          texts: [
                            BaseText.title('$code - $fantasyName '),
                            BaseText.title(
                              '(${enterpriseErrors.length})',
                              color: Colors.red,
                            ),
                          ],
                        ),
                        children: enterpriseErrors.map((item) {
                          return SynchronizerProductErrorItem(item: item);
                        }).toList(),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
