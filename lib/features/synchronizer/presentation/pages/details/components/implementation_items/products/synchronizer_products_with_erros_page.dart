import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/synchronizer/presentation/pages/components/components.dart';
import 'package:celta_inventario/features/synchronizer/presentation/pages/details/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SynchronizerProductsWithErrosPage extends ConsumerWidget {
  const SynchronizerProductsWithErrosPage({
    super.key,
    required this.items,
    required this.errorKey,
  });
  final List<EcProductWithErrorSynchronizerErrorGroupEntity> items;
  final String errorKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(
      selectedSynchronizerProductPageIndexStateControllerProvider,
    );

    return BaseScaffold(
      isScrollable: false,
      usePadding: false,
      bottomNavigationBar: BaseBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: ref
            .read(
              selectedSynchronizerProductPageIndexStateControllerProvider
                  .notifier,
            )
            .selectPageIndex,
        items: EcProductWithErrorType.values.map((type) {
          final group = items.firstWhereOrNull((e) => e.type == type);
          final quantity = group?.errors.length ?? 0;

          final IconData materialIcon;
          final IconData cupertinoIcon;

          switch (type) {
            case EcProductWithErrorType.error:
              materialIcon = Icons.error_outline;
              cupertinoIcon = CupertinoIcons.exclamationmark_circle;
            case EcProductWithErrorType.markedToSendAgain:
              materialIcon = Icons.sync;
              cupertinoIcon = CupertinoIcons.refresh;
            case EcProductWithErrorType.markedToIgnoreError:
              materialIcon = Icons.visibility_off_outlined;
              cupertinoIcon = CupertinoIcons.eye_slash;
          }

          final String label = switch (type) {
            EcProductWithErrorType.error => 'Erro'.hardcoded,
            EcProductWithErrorType.markedToSendAgain => 'Reenviar'.hardcoded,
            EcProductWithErrorType.markedToIgnoreError => 'Ignorados'.hardcoded,
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
      body: IndexedStack(
        index: currentIndex,
        children: EcProductWithErrorType.values.map((type) {
          final group = items.firstWhereOrNull((e) => e.type == type);
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
                  enterpriseErrors.firstOrNull?.enterpriseFantasyName ?? '';

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
    );
  }
}
