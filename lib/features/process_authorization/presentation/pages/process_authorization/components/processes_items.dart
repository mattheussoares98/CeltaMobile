import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ProcessesItems extends ConsumerWidget {
  final BSFProcessAuthorizationJudgementStatus status;
  const ProcessesItems({super.key, required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      value: ref.watch(judgmentsStateControllerProvider),
      tryAgain: () => ref.invalidate(judgmentsStateControllerProvider),
      data: (data) {
        final filteredData = data.where((e) => e.status == status).toList();

        return ResponsiveListFlow(
          itemCount: filteredData.length,
          itemBuilder: (context, index) {
            final e = filteredData[index];
            return Card(
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: () {
                  context.goNamed(
                    Routes.processAuthorizationDetails.name,
                    pathParameters: {
                      'enterpriseCode': e.enterprise!.code.toString(),
                      'processCode': e.code.toString(),
                    },
                  );
                },
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(Sizes.p8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TitleAndSubTitle(
                            title: null,
                            subTitle: e.enterprise?.name ?? '',
                          ),
                          TitleAndSubTitle(
                            title: null,
                            subTitle:
                                e.authorizationProcessItem?.category?.name ??
                                '',
                          ),
                          BaseText.titleMedium(
                            e.authorizationProcessItem?.name ?? '',
                          ),
                          if (e.dateTimeOfCreation != null)
                            TitleAndSubTitle(
                              title: 'Data',
                              subTitle: DateFormat(
                                'dd/MM/yyyy HH:mm:ss',
                              ).format(e.dateTimeOfCreation!),
                            ),
                          TitleAndSubTitle(
                            title: 'Processo iniciado por',
                            subTitle: e.user?.identification,
                          ),
                        ],
                      ),
                    ),
                    const Positioned(
                      bottom: Sizes.p8,
                      right: Sizes.p8,
                      child: PlatformIcon(
                        materialIcon: Icons.arrow_outward_rounded,
                        cupertinoIcon: CupertinoIcons.arrow_up_right,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
