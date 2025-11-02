import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/validators/validators.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class EmailPage extends ConsumerStatefulWidget {
  const EmailPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EmailPageState();
}

class _EmailPageState extends ConsumerState<EmailPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    final customer = ref.watch(customerStateControllerProvider).value;

    void insertEmail() {
      if (formKey.currentState?.validate() != true) {
        return;
      } else if (customer?.Emails?.any((e) => e == emailController.text) ??
          false) {
        showSnackBarMessage(
          context,
          'Esse e-mail já foi adicionado'.hardcoded,
          backgroundColor: Colors.red,
        );
        return;
      }

      ref
          .read(customerStateControllerProvider.notifier)
          .updateCustomer(
            customer!.copyWith(
              Emails: (customer.Emails ?? [])..add(emailController.text),
            ),
          );
      emailController.clear();
    }

    return Scaffold(
      appBar: AppBar(title: Text('E-mails'.hardcoded)),
      body: ResponsiveScrollableWidget(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              DefaultTextFormField(
                controller: emailController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                hintText: 'E-mail'.hardcoded,
                labelText: 'E-mail'.hardcoded,
                keyboardType: TextInputType.emailAddress,
                maxLength: 50,
                onFieldSubmitted: (_) {
                  insertEmail();
                },
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
              gapH32,
              PrimaryButton(
                text: 'Inserir e-mail'.hardcoded,
                onPressed: insertEmail,
              ),
              if (customer?.Emails != null && customer!.Emails!.isNotEmpty)
                const InformedEmails(),
            ],
          ),
        ),
      ),
    );
  }
}
