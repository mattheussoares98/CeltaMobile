enum SynchronizerErrorDetailType {
  coupon(1),
  couponMarkedToReadAgain(2),
  cashierMovement(3),
  fiscalNote(4),
  nFeDisable(5),
  schedule(6),
  transaction(7),
  treasuryMovement(8),
  mapSummarySaleEcf(9),
  customerWithError(10),
  customerWaitingApproval(11),
  saleRequestWithError(12),
  saleRequestWaitingApproval(13),
  saleRequestMarked(14),
  productWithError(15),
  readBleeding(16),
  correspondentBanking(17),
  saleMovementScanntechLoad(18),
  sendData(19);

  final int value;

  const SynchronizerErrorDetailType(this.value);

  static SynchronizerErrorDetailType fromValue(int value) => switch (value) {
    1 => coupon,
    2 => couponMarkedToReadAgain,
    3 => cashierMovement,
    4 => fiscalNote,
    5 => nFeDisable,
    6 => schedule,
    7 => transaction,
    8 => treasuryMovement,
    9 => mapSummarySaleEcf,
    10 => customerWithError,
    11 => customerWaitingApproval,
    12 => saleRequestWithError,
    13 => saleRequestWaitingApproval,
    14 => saleRequestMarked,
    15 => productWithError,
    16 => readBleeding,
    17 => correspondentBanking,
    18 => saleMovementScanntechLoad,
    19 => sendData,
    _ => throw FormatException(
      'Unsupported synchronizer error detail type: $value',
    ),
  };
}
