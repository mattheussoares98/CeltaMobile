import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../controllers/controllers.dart';

class EnterprisesPage extends ConsumerWidget {
  final String nextRoute;
  const EnterprisesPage(this.nextRoute, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterprisesAsync = ref.watch(enterprisesStateControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Empresas'.hardcoded)),
      body: AsyncValueWidget(
        value: enterprisesAsync,
        tryAgain: () => ref.invalidate(enterprisesStateControllerProvider),
        data: (enterprises) {
          return RefreshIndicator(
            onRefresh: () async =>
                //TODO test
                ref.invalidate(enterprisesStateControllerProvider),
            child: ListView.builder(
              itemCount: enterprises.length,
              itemBuilder: (_, index) {
                final enterprise = enterprises[index];
                return Card(
                  child: InkWell(
                    onTap: () {
                      context.pushNamed(nextRoute, extra: enterprise.Code);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(Sizes.p8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: enterprise.PersonalizedCode,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 10,
                              ),
                              children: [
                                TextSpan(
                                  text: ' ${enterprise.name}',
                                  style: theme.textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ),
                          if (enterprise.CnpjNumber != null)
                            RichText(
                              text: TextSpan(
                                text: 'CNPJ'.hardcoded,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 10,
                                ),
                                children: [
                                  TextSpan(
                                    text: ' ${enterprise.CnpjNumber}',
                                    style: theme.textTheme.titleSmall,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
