import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:collection/collection.dart';

class ProcessAuthorizationDestination {
  final Routes route;
  final Map<String, String> pathParameters;
  final int enterpriseCode;
  final int processCode;
  final int? saleRequestCode;
  final String? saleRequestNumber;

  const ProcessAuthorizationDestination({
    required this.route,
    required this.pathParameters,
    required this.enterpriseCode,
    required this.processCode,
    required this.saleRequestCode,
    required this.saleRequestNumber,
  });

  static ProcessAuthorizationDestination? fromJudgment(
    BSFProcessAuthorizationJudgmentEntity judgment,
  ) {
    final enterpriseCode = judgment.enterprise?.code;
    final processCode = judgment.code;
    if (enterpriseCode == null || processCode == null) return null;

    final type = judgment.authorizationProcessItem?.typeAccordingToTheCode;
    final route = switch (type) {
      TypeAccordingToTheCode.saleRequestDiscount ||
      TypeAccordingToTheCode.saleRequestLucrativity =>
        Routes.processAuthorizationSaleRequest,
      TypeAccordingToTheCode.goodsReceivingLiberateDocument ||
      TypeAccordingToTheCode.goodsReceivingCancelDocument =>
        Routes.processAuthorizationGR,
      TypeAccordingToTheCode.goodsReceivingValidateDocumentXml =>
        Routes.processAuthorizationGRValidateDocumentXml,
      _ => null,
    };
    if (route == null) return null;

    final saleRequest = judgment.defendants
        ?.whereType<BSFSaleRequestDefendantEntity>()
        .firstOrNull
        ?.saleRequest;
    final pathParameters = {
      'enterpriseCode': enterpriseCode.toString(),
      'processCode': processCode.toString(),
      if (route == Routes.processAuthorizationSaleRequest)
        'pageType': type == TypeAccordingToTheCode.saleRequestDiscount
            ? PageType.discount.name
            : PageType.lucrativity.name,
    };

    return ProcessAuthorizationDestination(
      route: route,
      pathParameters: pathParameters,
      enterpriseCode: enterpriseCode,
      processCode: processCode,
      saleRequestCode: judgment.saleRequestCode ?? saleRequest?.code,
      saleRequestNumber:
          judgment.saleRequestNumber ?? saleRequest?.personalizedCode,
    );
  }

  static ProcessAuthorizationDestination? nextSaleRequestJudgment({
    required BSFProcessAuthorizationJudgmentEntity current,
    required Iterable<BSFProcessAuthorizationJudgmentEntity> judgments,
    required String authorizatorIdentification,
  }) {
    final currentDestination = fromJudgment(current);
    if (currentDestination?.route != Routes.processAuthorizationSaleRequest ||
        currentDestination?.saleRequestCode == null) {
      return null;
    }

    for (final judgment in judgments) {
      if (judgment.code == current.code ||
          judgment.status != BSFProcessAuthorizationJudgementStatus.awaiting ||
          !(judgment.authorizators?.any(
                (authorizator) =>
                    authorizator.identification?.trim().toLowerCase() ==
                    authorizatorIdentification.trim().toLowerCase(),
              ) ??
              false)) {
        continue;
      }

      final destination = fromJudgment(judgment);
      if (destination?.route == Routes.processAuthorizationSaleRequest &&
          destination?.enterpriseCode == currentDestination!.enterpriseCode &&
          destination?.saleRequestCode == currentDestination.saleRequestCode) {
        return destination;
      }
    }

    return null;
  }
}
