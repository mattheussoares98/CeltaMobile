import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VoteBody extends ConsumerStatefulWidget {
  final int processCode;
  const VoteBody({super.key, required this.processCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VotePageState();
}

class _VotePageState extends ConsumerState<VoteBody> {
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
