import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/process_authorization/presentation/pages/vote/components/components.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
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
  final observationsController = TextEditingController();
  bool authorized = false;

  @override
  void dispose() {
    observationsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.observeLoading([voteControllerProvider(widget.processCode)]);
    ref.listen(voteControllerProvider(widget.processCode), (p, n) {
      n.showToastOnError(context, p);
      n.doOnSuccess(p, () {
        context.pop(true);
      });
    });
    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          UserDateAndLinkAccess(processCode: widget.processCode),
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
            controller: observationsController,
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
                  onPressed: context.pop,
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  text: 'Confirmar'.hardcoded,
                  onPressed: () {
                    ref
                        .read(
                          voteControllerProvider(widget.processCode).notifier,
                        )
                        .vote(
                          authorized,
                          observationsController.text.isEmpty
                              ? null
                              : observationsController.text,
                        );
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
