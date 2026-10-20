import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/enterprises/enterprises.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EnterprisesPage extends ConsumerWidget {
  final String nextRoute;
  const EnterprisesPage(this.nextRoute, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseScaffold(
      isScrollable: false,
      refreshProvider: enterprisesStateControllerProvider(),
      appBar: BaseAppBar(title: context.l10n.enterprises),
      body: AsyncValueWidget(
        value: ref.watch((enterprisesStateControllerProvider())),
        tryAgain: () => ref.invalidate(enterprisesStateControllerProvider),
        data: (enterprises) {
          return ListView.builder(
            itemCount: enterprises.length,
            itemBuilder: (_, index) {
              final enterprise = enterprises[index];
              return _EnterpriseItem(
                key: ValueKey(enterprise.Code),
                nextRoute: nextRoute,
                enterprise: enterprise,
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
                      text: context.l10n.cnpj,
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
