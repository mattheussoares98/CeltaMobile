import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/validators/validators.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';

class EmailField extends ConsumerStatefulWidget {
  const EmailField({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EmailFieldState();
}

class _EmailFieldState extends ConsumerState<EmailField> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  void insertEmail() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    final currentEmails = await ref.read(
      customerStateControllerProvider.selectAsync((s) => s?.Emails),
    );

    if (currentEmails?.any((e) => e == emailController.text) ?? false) {
      showSnackBarMessage(
        context,
        'Esse e-mail já foi adicionado'.hardcoded,
        backgroundColor: Colors.red,
      );
      return;
    }

    ref.read(customerStateControllerProvider.notifier).updateEmails([
      ...?currentEmails,
      emailController.text,
    ]);
    emailController.clear();

    formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return Column(
      children: [
        Form(
          key: formKey,
          child: DefaultTextFormField(
            controller: emailController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            hintText: 'E-mail'.hardcoded,
            labelText: 'E-mail'.hardcoded,
            keyboardType: TextInputType.emailAddress,
            maxLength: 50,
            onFieldSubmitted: (_) => insertEmail(),
            suffixIcon: IconButton(
              onPressed: emailController.clear,
              icon: Icon(
                isIOS ? CupertinoIcons.delete : Icons.delete,
                color: Colors.red,
              ),
            ),
            validator: FormValidators.compose([
              NonEmptyValidator(),
              EmailValidator(),
            ]),
          ),
        ),
        gapH32,
        PrimaryButton(text: 'Inserir e-mail'.hardcoded, onPressed: insertEmail),
      ],
    );
  }
}
