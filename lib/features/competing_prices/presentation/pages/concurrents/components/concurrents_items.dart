import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../domain/entities/entities.dart';

class ConcurrentsItems extends StatelessWidget {
  final List<ConcurrentEntity> concurrents;
  final ResearchEntity selectedResearch;
  const ConcurrentsItems({
    super.key,
    required this.concurrents,
    required this.selectedResearch,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    final mediaQuery = MediaQuery.of(context);

    return ListView.builder(
      itemCount: concurrents.length,
      itemBuilder: (context, index) {
        final concurrent = concurrents[index];

        bool? concurrentBindedInResearch = selectedResearch.Concurrents?.any(
          (e) => e.ConcurrentCode == concurrent.ConcurrentCode,
        );

        return Card(
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: TitleAndSubTitle(
                        title: 'Código'.hardcoded,
                        subTitle: concurrent.ConcurrentCode.toString(),
                      ),
                    ),
                    Flexible(
                      flex: 7,
                      child: PrimaryTextButton(
                        text: 'Alterar concorrente'.hardcoded,
                        onPressed: () {
                          //TODO open showModalPage to anable the user to change
                        },
                        icon: mediaQuery.size.width < 300
                            ? null
                            : Icon(isIOS ? CupertinoIcons.pencil : Icons.edit),
                      ),
                    ),
                  ],
                ),
                TitleAndSubTitle(
                  title: 'Nome'.hardcoded,
                  subTitle: concurrent.Name.toString(),
                ),
                TitleAndSubTitle(
                  title: null,
                  subTitle: concurrentBindedInResearch == true
                      ? 'Associado à pesquisa'.hardcoded
                      : 'Não associado à pesquisa'.hardcoded,
                  subTitleStyle: theme.textTheme.titleMedium?.copyWith(
                    color: concurrentBindedInResearch == true
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                if (concurrent.Observation != null &&
                    concurrent.Observation!.isNotEmpty)
                  TitleAndSubTitle(
                    title: 'Observação'.hardcoded,
                    subTitle: concurrent.Observation.toString(),
                  ),
                if (concurrent.Address != null &&
                    concurrent.Address!.Address.isNotEmpty)
                  Builder(
                    builder: (context) {
                      final address = StringBuffer();
                      address.write(concurrent.Address!.Address);
                      address.write(', ');
                      address.write(concurrent.Address!.District);
                      address.write(', ');
                      address.write(concurrent.Address!.City);
                      address.write(', ');
                      address.write(concurrent.Address!.Number);
                      address.write(', ');
                      address.write(concurrent.Address!.State?.name);
                      address.write('. CEP ');
                      address.write(concurrent.Address!.Zip);

                      return TitleAndSubTitle(
                        title: 'Endereço'.hardcoded,
                        subTitle: address,
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
