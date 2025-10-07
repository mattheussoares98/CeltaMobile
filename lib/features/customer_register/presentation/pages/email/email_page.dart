import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/validators/validators.dart';
import '../components/components.dart';

class EmailPage extends StatelessWidget {
  final List<String> emails;
  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;
  final VoidCallback addEmail;
  final void Function(int index) removeEmail;
  const EmailPage({
    super.key,
    required this.emails,
    required this.emailController,
    required this.formKey,
    required this.addEmail,
    required this.removeEmail,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    void insertEmail() {
      if (formKey.currentState?.validate() != true) {
        return;
      } else if (emails.any((e) => e == emailController.text)) {
        showSnackBarMessage(
          context,
          'Esse e-mail já foi adicionado'.hardcoded,
          backgroundColor: Colors.red,
        );
        return;
      }

      addEmail();
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
              if (emails.isNotEmpty) ...[
                DefaultDivider('E-mails informados'),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: emails.length,
                  itemBuilder: (_, index) {
                    final email = emails[index];

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
