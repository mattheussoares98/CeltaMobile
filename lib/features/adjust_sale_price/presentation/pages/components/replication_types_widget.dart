import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import 'components.dart';

class ReplicationTypesWidget extends StatelessWidget {
  final List<ReplicationTypes> replications;
  final bool? isSelectedClass;
  final bool? isSelectedGrid;
  final bool? isSelectedOperationalGrouping;
  final bool? isSelectedPackings;
  final void Function(ReplicationTypes replication) onChanged;
  const ReplicationTypesWidget({
    super.key,
    required this.replications,
    required this.isSelectedClass,
    required this.isSelectedGrid,
    required this.isSelectedOperationalGrouping,
    required this.isSelectedPackings,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleWidget(title: 'Parâmetros de replicação'.hardcoded),
        if (replications.contains(ReplicationTypes.packings))
          _ReplicationTypeItem(
            replicationType: ReplicationTypes.packings,
            isSelected: isSelectedPackings,
            onChanged: (_) {
              onChanged(ReplicationTypes.packings);
            },
          ),
        if (replications.contains(ReplicationTypes.grid))
          _ReplicationTypeItem(
            replicationType: ReplicationTypes.grid,
            isSelected: isSelectedGrid,
            onChanged: (_) {
              onChanged(ReplicationTypes.grid);
            },
          ),
        if (replications.contains(ReplicationTypes.classess))
          _ReplicationTypeItem(
            replicationType: ReplicationTypes.classess,
            isSelected: isSelectedClass,
            onChanged: (_) {
              onChanged(ReplicationTypes.classess);
            },
          ),
        if (replications.contains(ReplicationTypes.operationalGrouping))
          _ReplicationTypeItem(
            replicationType: ReplicationTypes.operationalGrouping,
            isSelected: isSelectedOperationalGrouping,
            onChanged: (_) {
              onChanged(ReplicationTypes.operationalGrouping);
            },
          ),
      ],
    );
  }
}

class _ReplicationTypeItem extends StatelessWidget {
  final ReplicationTypes replicationType;
  final bool? isSelected;
  final void Function(bool?)? onChanged;
  const _ReplicationTypeItem({
    required this.replicationType,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(replicationType.name),
      value: isSelected,
      onChanged: onChanged,
    );
  }
}
