import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/process_authorization/presentation/pages/process_authorization/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProcessAuthorizationPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  const ProcessAuthorizationPage({super.key, required this.enterpriseCode});

  @override
  ConsumerState<ProcessAuthorizationPage> createState() =>
      _ProcessAuthorizationPageState();
}

class _ProcessAuthorizationPageState
    extends ConsumerState<ProcessAuthorizationPage> {
  int index = 0;

  final pages = [
    const ProcessesItems(
      status: BSFProcessAuthorizationJudgementStatus.awaiting,
    ),
    const ProcessesItems(
      status: BSFProcessAuthorizationJudgementStatus.notAuthorized,
    ),
  ];

  final appBarTitles = [
    'Aguardando autorização'.hardcoded,
    'Não autorizados'.hardcoded,
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      isScrollable: false,
      refreshProvider: judgmentsStateControllerProvider,
      appBar: BaseAppBar(title: appBarTitles[index]),
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: Consumer(
        builder: (_, ref, _) {
          final awaitingQuantity = ref.watch(
            judgmentsStateControllerProvider.select(
              (s) => s.value
                  ?.where(
                    (e) =>
                        e.status ==
                        BSFProcessAuthorizationJudgementStatus.awaiting,
                  )
                  .length,
            ),
          );
          final notAuthorizedQuantity = ref.watch(
            judgmentsStateControllerProvider.select(
              (s) => s.value
                  ?.where(
                    (e) =>
                        e.status ==
                        BSFProcessAuthorizationJudgementStatus.notAuthorized,
                  )
                  .length,
            ),
          );
          return BaseBottomNavigationBar(
            items: [
              BaseBottomNavigationBarItem(
                badgeLabel: awaitingQuantity?.toString(),
                platformIcon: index == 0
                    ? const PlatformIcon(
                        cupertinoIcon: CupertinoIcons.hand_raised_fill,
                        materialIcon: Icons.back_hand_sharp,
                      )
                    : const PlatformIcon(
                        cupertinoIcon: CupertinoIcons.hand_raised,
                        materialIcon: Icons.back_hand_outlined,
                      ),
                label: 'Aguardando autorização'.hardcoded,
              ),
              BaseBottomNavigationBarItem(
                badgeLabel: notAuthorizedQuantity?.toString(),
                platformIcon: index == 1
                    ? const PlatformIcon(
                        cupertinoIcon: CupertinoIcons.padlock_solid,
                        materialIcon: Icons.lock,
                      )
                    : const PlatformIcon(
                        cupertinoIcon: CupertinoIcons.padlock,
                        materialIcon: Icons.lock_outline,
                      ),
                label: 'Não autorizados'.hardcoded,
              ),
            ],
            currentIndex: index,
            onTap: (value) => setState(() => index = value),
          );
        },
      ),
    );
  }
}
