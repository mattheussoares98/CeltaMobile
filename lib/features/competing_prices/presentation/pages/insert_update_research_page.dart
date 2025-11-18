import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../../core/validators/validators.dart';
import '../../../../localization/string_hardcoded.dart';
import '../../domain/entities/entities.dart';

class InsertUpdateResearchPage extends ConsumerStatefulWidget {
  final ResearchEntity? research; //if is null, is inserting
  const InsertUpdateResearchPage({super.key, required this.research});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InsertUpdateResearchPageState();
}

class _InsertUpdateResearchPageState
    extends ConsumerState<InsertUpdateResearchPage> {
  final nameController = TextEditingController();
  final observarionsController = TextEditingController();
  final observationsFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();

    nameController.dispose();
    observarionsController.dispose();
    observationsFocusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        if (widget.research != null) {
          nameController.text = widget.research!.Name!;
          observarionsController.text = widget.research!.Observation ?? '';
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Column(
          children: [
            Text(
              widget.research == null
                  ? 'Inserindo Pesquisa'.hardcoded
                  : 'Editando Pesquisa'.hardcoded,
              style: theme.textTheme.titleLarge,
            ),
            gapH32,
            DefaultTextFormField(
              controller: nameController,
              labelText: 'Nome'.hardcoded,
              hintText: 'Nome'.hardcoded,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              maxLength: 100,
              validator: FormValidators.compose([NonEmptyValidator()]),
              onFieldSubmitted: (_) {
                observationsFocusNode.requestFocus();
              },
            ),
            gapH8,
            DefaultTextFormField(
              controller: observarionsController,
              focusNode: observationsFocusNode,
              labelText: 'Observações'.hardcoded,
              hintText: 'Observações'.hardcoded,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              maxLength: 300,
              onFieldSubmitted: (_) {
                //TODO insertUpdate
              },
            ),
            gapH32,
            PrimaryButton(
              text: widget.research == null
                  ? 'Inserir'.hardcoded
                  : 'Editar'.hardcoded,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
