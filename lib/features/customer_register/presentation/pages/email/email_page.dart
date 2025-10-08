import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/validators/validators.dart';
import '../../controllers/controllers.dart';
import '../components/components.dart';

class EmailPage extends ConsumerWidget {
  final CustomerEntity? customer;
  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;
  const EmailPage({
    super.key,
    required this.emailController,
    required this.formKey,
    required this.customer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

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
              Emails: (customer?.Emails ?? [])..add(emailController.text),
            ),
          );
      emailController.clear();
    }

    void removeEmail(int index) {
      ref
          .read(customerStateControllerProvider.notifier)
          .updateCustomer(
            customer!.copyWith(Emails: [...customer!.Emails!..removeAt(index)]),
          );
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
              if (customer?.Emails != null && customer!.Emails!.isNotEmpty) ...[
                DefaultDivider('E-mails informados'),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: customer!.Emails!.length,
                  itemBuilder: (_, index) {
                    final email = customer!.Emails![index];

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.only(left: Sizes.p8),
                        child: Row(
                          children: [
                            Expanded(child: Text(email)),
                            IconButton(
                              onPressed: () {
                                showAlertDialog(
                                  context: context,
                                  title: 'Remover e-mail?'.hardcoded,
                                  onOkPressed: () => removeEmail(index),
                                  defaultActionText: 'Sim'.hardcoded,
                                  cancelActionText: 'Não'.hardcoded,
                                );
                              },
                              icon: Icon(
                                isIOS ? CupertinoIcons.delete : Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
