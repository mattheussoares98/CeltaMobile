import 'package:celta_inventario/core/domain/errors/errors.dart';
import 'package:celta_inventario/localization/generated/generated.dart';

extension CoreFailureLocalizations on AppLocalizations {
  String coreFailure(
    CoreFailure failure, [
    List<String> arguments = const [],
  ]) => switch (failure) {
    CoreFailure.invalidSession => invalidSession,
    CoreFailure.postalCodeNotFound => postalCodeNotFound,
    CoreFailure.noWorkingUrl => noWorkingUrl,
    CoreFailure.unsupportedDownload => unsupportedDownload,
    CoreFailure.selectSaveFolder => selectSaveFolder,
    CoreFailure.unexpectedLoginError => unexpectedLoginError,
    CoreFailure.invalidResponseStructure => invalidResponseStructure,
    CoreFailure.httpBadRequest => httpBadRequest,
    CoreFailure.httpNotFound => httpNotFound,
    CoreFailure.httpServerError => httpServerError,
    CoreFailure.httpUnauthorized => httpUnauthorized,
    CoreFailure.httpForbidden => httpForbidden,
    CoreFailure.httpInvalidData => httpInvalidData,
    CoreFailure.companyNotFound => companyNotFound,
    CoreFailure.purchasePeriodTooLong => purchasePeriodTooLong,
    CoreFailure.quotationBuyerRequired => quotationBuyerRequired,
    CoreFailure.quotationEnterpriseRequired => quotationEnterpriseRequired,
    CoreFailure.quotationProductRequired => quotationProductRequired,
    CoreFailure.priceSurveyCodeRequired => priceSurveyCodeRequired,
    CoreFailure.cannotOpenUrl => cannotOpenUrl(arguments.first),
  };
}
