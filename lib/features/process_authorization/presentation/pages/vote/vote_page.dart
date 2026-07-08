import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class VotePage extends ConsumerStatefulWidget {
  final int processCode;
  const VotePage({super.key, required this.processCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VotePageState();
}

class _VotePageState extends ConsumerState<VotePage> {
  final voteController = TextEditingController();
  bool authorized = false;

  @override
  void dispose() {
    voteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Consumer(
            builder: (_, ref, _) {
              final judgmentDetails = ref
                  .watch(
                    judgmentDetailsStateControllerProvider(widget.processCode),
                  )
                  .value;

              final saleRequest = judgmentDetails?.defendants
                  ?.cast<BSFSaleRequestDefendantEntity>()
                  .firstOrNull
                  ?.saleRequest;

              if (saleRequest == null) {
                return const SizedBox.shrink();
              }
              //TODO Show this Card according to the process type

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.p8),
                  child: Column(
                    crossAxisAlignment: .stretch,
                    children: [
                      if (judgmentDetails
                              ?.user
                              ?.crossIdentity
                              ?.identification !=
                          null)
                        TitleAndSubTitle(
                          title: 'Iniciado por'.hardcoded,
                          subTitle: judgmentDetails
                              ?.user
                              ?.crossIdentity
                              ?.identification,
                        ),
                      if (saleRequest.personalizedCode != null)
                        TitleAndSubTitle(
                          title: 'Núm do pedido'.hardcoded,
                          subTitle: saleRequest.personalizedCode?.toString(),
                        ),
                      if (saleRequest.dateOfEmission != null)
                        TitleAndSubTitle(
                          title: 'Data'.hardcoded,
                          subTitle: saleRequest.dateOfEmission?.formatDate(
                            DateFormatType.ddMMyyyyHHmm,
                          ),
                        ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: PrimaryTextButton(
                          text: 'Visualizar pedido'.hardcoded,
                          onPressed: () {
                            context.pushNamed(
                              Routes.saleRequestDetails.name,
                              pathParameters: {
                                'saleRequestId': saleRequest.code.toString(),
                                'enterpriseCode': saleRequest.enterprise!.code
                                    .toString(),
                                'customerCode': saleRequest.customer!.code
                                    .toString(),
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          BaseRadio(
            name: 'Autorizado'.hardcoded,
            value: true,
            groupValue: authorized,
            onChanged: (value) => setState(() => authorized = value ?? false),
          ),
          BaseRadio(
            name: 'Não autorizado'.hardcoded,
            value: false,
            groupValue: authorized,
            activeColor: Colors.red,
            onChanged: (value) => setState(() => authorized = value ?? false),
          ),
          gapH16,
          BaseTextFormField(
            labelText: 'Observações'.hardcoded,
            hintText: 'Observações'.hardcoded,
            maxLines: 5,
            maxLength: 300,
          ),
          gapH32,
          Row(
            children: [
              Flexible(
                child: PrimaryTextButton(
                  text: 'Cancelar'.hardcoded,
                  color: Colors.red,
                  onPressed: Navigator.of(context).pop,
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  text: 'Confirmar'.hardcoded,
                  onPressed: () {
                    //TODO call the vote controller method
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
