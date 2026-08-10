import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/providers/services/crashlytics_service.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotImplementedDetailType extends ConsumerStatefulWidget {
  const NotImplementedDetailType({
    super.key,
    required this.detailType,
    required this.errorKey,
  });

  final SynchronizerErrorDetailType detailType;
  final String errorKey;

  @override
  ConsumerState<NotImplementedDetailType> createState() =>
      _NotImplementedDetailTypeState();
}

class _NotImplementedDetailTypeState
    extends ConsumerState<NotImplementedDetailType> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(crashlyticsServiceProvider)
          .recordNonFatalError(
            exception: UnimplementedError(
              'NotImplementedDetailType triggered for ${widget.detailType.name}',
            ),
            stackTrace: StackTrace.current,
            reason: 'Synchronizer error type not implemented in UI',
            customKeys: [
              CrashlyticsCustomKeyEntity(
                key: 'detail_type',
                value: widget.detailType.name,
              ),
              CrashlyticsCustomKeyEntity(
                key: 'error_key',
                value: widget.errorKey,
              ),
            ],
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BaseText.error(
        'A visualização desse tipo de erro ainda não foi implementada'
            .hardcoded,
      ),
    );
  }
}
