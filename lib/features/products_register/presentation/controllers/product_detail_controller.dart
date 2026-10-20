import 'package:celta_inventario/localization/localization.dart';
import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/products_register/domain/entities/entities.dart';
import 'package:celta_inventario/features/products_register/providers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_detail_controller.g.dart';

@riverpod
class ProductDetailController extends _$ProductDetailController {
  @override
  FutureOr<BsfProductEntity> build({
    required int enterpriseCode,
    required int productCode,
  }) async {
    ref.cache();

    final ecParams = await ref.watch(ecRequestParamsProvider().future);

    return ref
        .read(ecProductRepositoryProvider)
        .get(
          ecParams,
          productCode: productCode,
          enterpriseCode: enterpriseCode,
        );
  }

  List<BsfProductPropertyEntity> search(
    String query, {
    AppLocalizations? translations,
  }) {
    final entity = state.value;
    if (entity == null) return [];
    final l10n = translations ?? defaultLocalizations;
    final properties = entity.toSearchIndex(
      codeLabel: l10n.code,
      nameLabel: l10n.name,
      deactivatedLabel: l10n.deactivatedProperty,
      fiscalClassificationLabel: l10n.fiscalClassificationProperty,
      yesLabel: l10n.yes,
      noLabel: l10n.no,
    );
    if (query.trim().isEmpty) return properties;

    final lowerQuery = query.toLowerCase();
    return properties
        .where((p) => p.labelPt.toLowerCase().contains(lowerQuery))
        .toList();
  }
}
