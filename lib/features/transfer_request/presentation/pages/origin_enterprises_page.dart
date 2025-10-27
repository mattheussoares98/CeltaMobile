import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import '../../../../constants/constants.dart';
import '../../../enterprise_manager/domain/entities/entities.dart';
import '../../../enterprises/presentation/controllers/controllers.dart';

class OriginEnterprisesPage extends ConsumerWidget {
  final int requestTypeCode;
  const OriginEnterprisesPage({super.key, required this.requestTypeCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterprisesAsync = ref.watch(
      enterprisesStateControllerProvider(module: Modules.transferRequest),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Empresa de origem'.hardcoded)),
      body: AsyncValueWidget(
        value: enterprisesAsync,
        tryAgain: () {
          ref.invalidate(
            enterprisesStateControllerProvider(module: Modules.transferRequest),
          );
        },
        data: (enterprises) {
          //TODO treat if the enterprise is enabled or not
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(
                enterprisesStateControllerProvider(
                  module: Modules.transferRequest,
                ),
              );
            },
            child: ListView.builder(
              itemCount: enterprises.length,
              itemBuilder: (_, index) {
                final enterprise = enterprises[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      //TODO navigate to destiny enterprises page
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(Sizes.p8),
                      child: Column(
                        children: [
                          TitleAndSubTitle(
                            title: null,
                            subTitle:
                                '${enterprise.PersonalizedCode} - ${enterprise.name}',
                          ),
                          TitleAndSubTitle(
                            title: 'CNPJ'.hardcoded,
                            subTitle: enterprise.CnpjNumber,
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
