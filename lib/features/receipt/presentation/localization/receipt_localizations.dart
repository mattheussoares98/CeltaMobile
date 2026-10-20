import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';
import 'package:celta_inventario/localization/generated/generated.dart';

extension ReceiptLocalizations on AppLocalizations {
  String receiptStatusName(Status value) => switch (value) {
    Status.usedByAnotherEntry => receiptCompleted,
    Status.canceled => receiptCanceled,
    Status.countingProducts => countingReceiptProducts,
    Status.liberatedForEntry => receiptReleasedAwaitingEntry,
    Status.inProcessOfAuthorization => receiptUnderAuthorization,
    Status.awaitingMaintenanceOfProducts => receiptAwaitingProductMaintenance,
    Status.awaitingEntryLiberation => receiptAwaitingRelease,
    Status.unknownStatus => receiptUnknownStatus,
  };

  String productJudgmentTypeName(BsfGRProductJudgmentType value) =>
      switch (value) {
        BsfGRProductJudgmentType.requestForFiscalNote => orderToInvoiceJudgment,
        BsfGRProductJudgmentType.fiscalNoteForCounting =>
          invoiceToCountJudgment,
        BsfGRProductJudgmentType.requestForCounting => orderToCountJudgment,
      };

  String productJudgmentStatusName(BsfGRProductJudgmentStatus value) =>
      switch (value) {
        BsfGRProductJudgmentStatus.withoutJudge => withoutJudgment,
        BsfGRProductJudgmentStatus.accept => acceptedJudgment,
        BsfGRProductJudgmentStatus.devolveAll => returnAllJudgment,
        BsfGRProductJudgmentStatus.devolveExcess => returnExcess,
      };
}
