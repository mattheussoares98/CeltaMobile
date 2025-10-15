import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../core/domain/entities/entities.dart';
import '../../domain/entities/entities.dart';
import '../controllers/controllers.dart';

class CountingsPage extends ConsumerWidget {
  final int codigoInternoInventario;
  final int enterpriseCode;
  final EnterpriseEntity? selectedEnterprise;
  final List<CountingEntity>? countings;
  const CountingsPage({
    super.key,
    required this.codigoInternoInventario,
    required this.enterpriseCode,
    required this.selectedEnterprise,
    required this.countings,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Contagens'.hardcoded)),
      body: countings == null
          ? AsyncValueWidget(
              value: ref.watch(
                inventoryStateControllerProvider(
                  enterpriseCode,
                  selectedEnterprise?.name ?? '',
                ),
              ),
              tryAgain: () {
                ref.invalidate(
                  inventoryStateControllerProvider(
                    enterpriseCode,
                    selectedEnterprise?.name ?? '',
                  ),
                );
              },
              data: (inventory) {
                final countings = inventory?.countings
                    .where(
                      (e) => codigoInternoInventario == e.CodigoInternoInvCont,
                    )
                    .toList();
                if (countings == null || countings.isEmpty) {
                  return Text(
                    'Não foram encontradas contagens para esse processe de inventário. Crie pelo menos uma contagem'
                        .hardcoded,
                  );
                }

                return ListView.builder(
                  itemCount: inventory?.countings.length ?? 0,
                  itemBuilder: (_, index) {
                    final counting = inventory!.countings[index];
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          TitleAndSubTitle(
                            title: 'Número'.hardcoded,
                            subTitle: counting.NumeroContagemInvCont.toString(),
                          ),
                          if (counting.ObsInvCont != null)
                            TitleAndSubTitle(
                              title: 'Obs'.hardcoded,
                              subTitle: counting.ObsInvCont,
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            )
          : ListView.builder(
              itemCount: countings?.length ?? 0,
              itemBuilder: (_, index) {
                final counting = countings![index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      TitleAndSubTitle(
                        title: 'Número'.hardcoded,
                        subTitle: counting.NumeroContagemInvCont.toString(),
                      ),
                      if (counting.ObsInvCont != null)
                        TitleAndSubTitle(
                          title: 'Obs'.hardcoded,
                          subTitle: counting.ObsInvCont,
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
