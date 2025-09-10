import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../controllers/controllers.dart';
import 'components/components.dart';

class EnterpriseManagerPage extends ConsumerStatefulWidget {
  const EnterpriseManagerPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EnterpriseManagerPageState();
}

class _EnterpriseManagerPageState extends ConsumerState<EnterpriseManagerPage> {
  final enterpriseNameController = TextEditingController();
  final urlController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final urlFocusNode = FocusNode();
  final userNameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();

    enterpriseNameController.dispose();
    urlController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    urlFocusNode.dispose();
    userNameFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  Future<void> onSubmit() async {
    await ref
        .read(createEnterpriseControllerProvider.notifier)
        .createEnterprise(
          baseUrl: urlController.text,
          enterpriseName: enterpriseNameController.text,
          password: passwordController.text,
          userName: userNameController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final permissionsAsync = ref.watch(enterpriseManagerControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Módulos'.hardcoded),
        actions: [LogoutButton()],
      ),
      floatingActionButton: CreateEnterpriseFlottingButton(
        enterpriseNameController: enterpriseNameController,
        urlController: urlController,
        userNameController: userNameController,
        passwordController: passwordController,
        urlFocusNode: urlFocusNode,
        userNameFocusNode: userNameFocusNode,
        passwordFocusNode: passwordFocusNode,
        onSubmit: onSubmit,
      ),
      body: AsyncValueWidget(
        value: permissionsAsync,
        tryAgain: () => ref.invalidate(enterpriseManagerControllerProvider),
        data: (enterprises) {
          if (enterprises.isEmpty) {
            return Center(child: Text('Nenhuma empresa encontrada.'.hardcoded));
          }
          // Build a list of enterprises
          return ListView.builder(
            itemCount: enterprises.length,
            itemBuilder: (context, index) {
              final enterprise = enterprises[index];
              return ExpansionTile(
                title: Text(
                  enterprise.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                children: enterprise.subEnterprises.map((cnpj) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 8.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${cnpj.name} (${cnpj.cnpjNumber})',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        // Build the list of module switches for this CNPJ
                        // ...cnpj.modules.map((module) {
                        //   return SwitchListTile(
                        //     title: Text(module.name),
                        //     value: module.isEnabled,
                        //     onChanged: (newValue) {
                        //       // Call the controller to update the permission
                        //       ref
                        //           .read(
                        //             enterpriseManagerControllerProvider
                        //                 .notifier,
                        //           )
                        //           .updatePermission(
                        //             subEnterpriseId: cnpj.id,
                        //             moduleId: module.id,
                        //             isEnabled: newValue,
                        //           );
                        //     },
                        //   );
                        // }),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
