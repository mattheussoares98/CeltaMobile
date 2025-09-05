import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../controllers/controllers.dart';

class EnterpriseManagerPage extends ConsumerWidget {
  const EnterpriseManagerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the controller that fetches all the data
    final permissionsAsync = ref.watch(enterprisesManagementControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Gerenciar Módulos'.hardcoded)),
      // Use your reusable widget to handle loading/error states
      body: AsyncValueWidget(
        value: permissionsAsync,
        tryAgain: () => ref.invalidate(enterprisesManagementControllerProvider),
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
                        //             enterprisesManagementControllerProvider
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
