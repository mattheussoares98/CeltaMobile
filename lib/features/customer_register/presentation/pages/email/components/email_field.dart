import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/customer_register/presentation/controllers/controllers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    final customer = await ref.read(customerStateControllerProvider.future);
    final currentEmails = customer?.Emails;

    if (currentEmails?.any((e) => e == emailController.text) ?? false) {
      if (!mounted) return;
      showToastMessage(
        context.l10n.thisEmailHasAlreadyBeenAdded,
        type: ToastType.error,
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
    return Column(
      children: [
        Form(
          key: formKey,
          child: BaseTextFormField(
            controller: emailController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            hintText: context.l10n.email,
            labelText: context.l10n.email,
            keyboardType: TextInputType.emailAddress,
            onFieldSubmitted: (_) => insertEmail(),
            suffixIcon: IconButton(
              onPressed: emailController.clear,
              icon: const PlatformIcon(
                cupertinoIcon: CupertinoIcons.delete,
                materialIcon: Icons.delete,
                color: Colors.red,
              ),
            ),
            validator: FormValidators.compose([
              NonEmptyValidator(translations: context.l10n),
              EmailValidator(translations: context.l10n),
            ]),
          ),
        ),
        gapH32,
        PrimaryButton(text: context.l10n.enterEmail, onPressed: insertEmail),
      ],
    );
  }
}
