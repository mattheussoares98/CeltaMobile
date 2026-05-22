import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/enterprise_manager/domain/entities/entities.dart';
import 'package:celta_inventario/features/enterprise_manager/presentation/pages/enterprise_manager/enterprises/components/components.dart';

class EnterpriseItems extends ConsumerStatefulWidget {
  final List<EnterprisePermissionEntity> enterprises;
  final TextEditingController filterEnterpriseNameController;
  const EnterpriseItems({
    super.key,
    required this.enterprises,
    required this.filterEnterpriseNameController,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EnterpriseItemsState();
}

class _EnterpriseItemsState extends ConsumerState<EnterpriseItems> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: DefaultTextFormField(
              controller: widget.filterEnterpriseNameController,
              onChanged: (_) {},
              hintText: "Filtrar empresa",
              labelText: 'Filtrar empresa',
            ),
          ),
        ),
        FilteredEnterprises(
          enterprises: widget.enterprises,
          filterController: widget.filterEnterpriseNameController,
        ),
        gapSliverH120,
      ],
    );
  }
}
