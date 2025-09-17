import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../constants/constants.dart';
import '../../../domain/entities/entities.dart';
import 'components.dart';

class ReplicationTypesWidget extends StatelessWidget {
  final List<ReplicationTypes> availableReplications;
  final Set<ReplicationTypes> selectedReplications;
  final void Function(ReplicationTypes replication) onChanged;
  const ReplicationTypesWidget({
    super.key,
    required this.onChanged,
    required this.availableReplications,
    required this.selectedReplications,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        TitleWidget(title: 'Parâmetros de replicação'.hardcoded),
        ...availableReplications.map((replication) {
          return CheckboxListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: Sizes.p8),
            title: Text(replication.name, style: theme.textTheme.bodyMedium),
            value: selectedReplications.contains(replication),
            onChanged: (_) {
              onChanged(replication);
            },
          );
        }),
      ],
    );
  }
}
