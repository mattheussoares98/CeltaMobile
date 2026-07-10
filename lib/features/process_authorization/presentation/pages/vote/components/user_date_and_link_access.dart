import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/process_authorization/presentation/pages/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserDateAndLinkAccess extends ConsumerWidget {
  final int processCode;
  const UserDateAndLinkAccess({super.key, required this.processCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      value: ref.watch(judgmentDetailsStateControllerProvider(processCode)),
      tryAgain: () =>
          ref.invalidate(judgmentDetailsStateControllerProvider(processCode)),
      data: (judgmentDetails) {
        return Column(
          children: [
            switch (judgmentDetails
                .authorizationProcessItem
                ?.typeAccordingToTheCode) {
              TypeAccordingToTheCode.saleRequestDiscount =>
                OpenSaleRequestDetailsPageButton(
                  title: 'Visualizar pedido'.hardcoded,
                  processCode: processCode,
                ),
              TypeAccordingToTheCode.receiptLiberateDocument =>
                const SizedBox.shrink(), //TODO implement
              TypeAccordingToTheCode.saleRequestLucrativity =>
                const SizedBox.shrink(), //TODO implement
              null => const SizedBox.shrink(),
            },

            Card(
              child: Padding(
                padding: const EdgeInsets.all(Sizes.p8),
                child: Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    if (judgmentDetails.user?.crossIdentity?.identification !=
                        null)
                      TitleAndSubTitle(
                        title: 'Iniciado por'.hardcoded,
                        subTitle:
                            judgmentDetails.user?.crossIdentity?.identification,
                      ),
                    if (judgmentDetails.dateTimeOfCreation != null)
                      TitleAndSubTitle(
                        title: 'Data'.hardcoded,
                        subTitle: judgmentDetails.dateTimeOfCreation
                            ?.formatDate(DateFormatType.ddMMyyyyHHmm),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
