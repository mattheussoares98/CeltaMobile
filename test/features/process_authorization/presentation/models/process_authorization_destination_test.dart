import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/presentation/models/models.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/mocks.dart';

void main() {
  group('ProcessAuthorizationDestination', () {
    test('maps a SaleRequest judgment and exposes its number', () {
      final judgment = EntityFactory.makeBSFProcessAuthorizationJudgmentEntity(
        code: 10,
        saleRequestCode: 55,
        saleRequestNumber: 'PV-55',
        authorizationProcessItem:
            EntityFactory.makeBSFProcessAuthorizationItemEntity(
              typeAccordingToTheCode:
                  TypeAccordingToTheCode.saleRequestDiscount,
            ),
      );

      final destination = ProcessAuthorizationDestination.fromJudgment(
        judgment,
      );

      expect(destination?.route, Routes.processAuthorizationSaleRequest);
      expect(destination?.processCode, 10);
      expect(destination?.saleRequestCode, 55);
      expect(destination?.saleRequestNumber, 'PV-55');
      expect(destination?.pathParameters['pageType'], 'discount');
    });

    test('finds another awaiting judgment for the same SaleRequest', () {
      final enterprise = EntityFactory.makeBSFEnterpriseEntity();
      final current = EntityFactory.makeBSFProcessAuthorizationJudgmentEntity(
        code: 10,
        status: BSFProcessAuthorizationJudgementStatus.awaiting,
        saleRequestCode: 55,
        saleRequestNumber: 'PV-55',
        enterprise: enterprise,
        authorizationProcessItem:
            EntityFactory.makeBSFProcessAuthorizationItemEntity(
              typeAccordingToTheCode:
                  TypeAccordingToTheCode.saleRequestDiscount,
            ),
      );
      final next = EntityFactory.makeBSFProcessAuthorizationJudgmentEntity(
        code: 11,
        status: BSFProcessAuthorizationJudgementStatus.awaiting,
        saleRequestCode: 55,
        saleRequestNumber: 'PV-55',
        enterprise: enterprise,
        authorizationProcessItem:
            EntityFactory.makeBSFProcessAuthorizationItemEntity(
              typeAccordingToTheCode:
                  TypeAccordingToTheCode.saleRequestLucrativity,
            ),
      );

      final destination =
          ProcessAuthorizationDestination.nextSaleRequestJudgment(
            current: current,
            judgments: [current, next],
            authorizatorIdentification:
                next.authorizators!.first.identification!,
          );

      expect(destination?.processCode, 11);
      expect(destination?.pathParameters['pageType'], 'lucrativity');
    });

    test('ignores finished and unrelated SaleRequest judgments', () {
      final enterprise = EntityFactory.makeBSFEnterpriseEntity();
      final saleRequestItem =
          EntityFactory.makeBSFProcessAuthorizationItemEntity(
            typeAccordingToTheCode: TypeAccordingToTheCode.saleRequestDiscount,
          );
      final current = EntityFactory.makeBSFProcessAuthorizationJudgmentEntity(
        code: 10,
        saleRequestCode: 55,
        enterprise: enterprise,
        authorizationProcessItem: saleRequestItem,
      );
      final finished = EntityFactory.makeBSFProcessAuthorizationJudgmentEntity(
        code: 11,
        status: BSFProcessAuthorizationJudgementStatus.authorized,
        saleRequestCode: 55,
        enterprise: enterprise,
        authorizationProcessItem: saleRequestItem,
      );
      final unrelated = EntityFactory.makeBSFProcessAuthorizationJudgmentEntity(
        code: 12,
        status: BSFProcessAuthorizationJudgementStatus.awaiting,
        saleRequestCode: 56,
        enterprise: enterprise,
        authorizationProcessItem: saleRequestItem,
      );

      final destination =
          ProcessAuthorizationDestination.nextSaleRequestJudgment(
            current: current,
            judgments: [current, finished, unrelated],
            authorizatorIdentification:
                finished.authorizators!.first.identification!,
          );

      expect(destination, isNull);
    });
  });
}
