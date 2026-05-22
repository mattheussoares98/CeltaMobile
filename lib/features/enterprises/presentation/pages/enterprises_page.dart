import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/enterprises/enterprises.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:celta_inventario/utils/utils.dart';

class EnterprisesPage extends ConsumerWidget {
  final String nextRoute;
  const EnterprisesPage(this.nextRoute, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Empresas'.hardcoded)),
      body: Consumer(
        builder: (context, ref, child) {
          return AsyncValueWidget(
            value: ref.watch((enterprisesStateControllerProvider())),
            tryAgain: () => ref.invalidate(enterprisesStateControllerProvider),
            data: (enterprises) {
              return RefreshIndicator(
                onRefresh: () async =>
                    ref.invalidate(enterprisesStateControllerProvider),
                child: ListView.builder(
                  itemCount: enterprises.length,
                  itemBuilder: (_, index) {
                    final enterprise = enterprises[index];
                    return _EnterpriseItem(
                      key: ValueKey(enterprise.Code),
                      nextRoute: nextRoute,
                      enterprise: enterprise,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _EnterpriseItem extends StatelessWidget {
  final String nextRoute;
  final EnterpriseEntity enterprise;
  const _EnterpriseItem({
    super.key,
    required this.nextRoute,
    required this.enterprise,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Card(
        child: InkWell(
          onTap: () {
            context.goNamed(
              nextRoute,
              pathParameters: {
                'enterpriseCode': enterprise.Code.toString(),
                'nextRoute': nextRoute,
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: enterprise.PersonalizedCode,
                    style: context.theme.textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                    ),
                    children: [
                      TextSpan(
                        text: ' ${enterprise.name}',
                        style: context.theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                if (enterprise.CnpjNumber != null)
                  RichText(
                    text: TextSpan(
                      text: 'CNPJ'.hardcoded,
                      style: context.theme.textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                      ),
                      children: [
                        TextSpan(
                          text: ' ${enterprise.CnpjNumber}',
                          style: context.theme.textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
