import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/localization/generated/generated.dart';

extension ProcessAuthorizationLocalizations on AppLocalizations {
  String authorizationProcessType(TypeAccordingToTheCode value) =>
      switch (value) {
        TypeAccordingToTheCode.goodsReceivingValueDocument =>
          goodsReceiptDocumentValue,
        TypeAccordingToTheCode.goodsReceivingCancelDocument =>
          goodsReceiptDocumentCancellation,
        TypeAccordingToTheCode.goodsReceivingLiberateDocument =>
          goodsReceiptDocumentRelease,
        TypeAccordingToTheCode.goodsReceivingValidateDocumentXml =>
          goodsReceiptXmlValidation,
        TypeAccordingToTheCode.goodsReceivingValidatePaymentCondition =>
          goodsReceiptPaymentTermsValidation,
        TypeAccordingToTheCode.saleRequestLucrativity =>
          salesOrderBelowMinimumPrice,
        TypeAccordingToTheCode.saleRequestDiscount => salesOrderExcessDiscount,
      };

  String userBondName(BSFUserBondType value) => switch (value) {
    BSFUserBondType.employee => employeeBond,
    BSFUserBondType.customer => customer,
    BSFUserBondType.supplier => supplier,
    BSFUserBondType.simpleUser => simpleUserBond,
  };

  String authorizationJudgmentType(
    BSFProcessAuthorizationJudgementType value,
  ) => switch (value) {
    BSFProcessAuthorizationJudgementType.anyUserCanAuthorize =>
      anyUserCanAuthorize,
    BSFProcessAuthorizationJudgementType.allUsersShouldAuthorize =>
      allUsersShouldAuthorize,
    BSFProcessAuthorizationJudgementType.closedProcess => closedProcess,
    BSFProcessAuthorizationJudgementType.definedForTheDefendantHandler =>
      definedForHandler,
  };

  String authorizationStatus(BSFProcessAuthorizationJudgementStatus value) =>
      switch (value) {
        BSFProcessAuthorizationJudgementStatus.awaiting =>
          awaitingAuthorization,
        BSFProcessAuthorizationJudgementStatus.notAuthorized => unauthorized,
        BSFProcessAuthorizationJudgementStatus.authorized => authorized,
      };
}
