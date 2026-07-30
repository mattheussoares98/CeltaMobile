enum SynchronizerErrorDetailType {
  coupon(1),
  cashierMovement(2),
  fiscalNote(3),
  nFeDisable(4),
  schedule(5),
  transaction(6),
  treasuryMovement(7),
  mapSummarySaleEcf(8),
  customerWithError(9),
  customerWaitingApproval(10),
  saleRequestWithError(11),
  saleRequestWaitingApproval(12),
  saleRequestMarked(13),
  productWithError(14),
  readBleeding(15),
  correspondentBanking(16),
  saleMovementScanntechLoad(17),
  sendData(18);

  final int value;

  const SynchronizerErrorDetailType(this.value);

  static SynchronizerErrorDetailType fromValue(int value) => switch (value) {
    1 => coupon,
    2 => cashierMovement,
    3 => fiscalNote,
    4 => nFeDisable,
    5 => schedule,
    6 => transaction,
    7 => treasuryMovement,
    8 => mapSummarySaleEcf,
    9 => customerWithError,
    10 => customerWaitingApproval,
    11 => saleRequestWithError,
    12 => saleRequestWaitingApproval,
    13 => saleRequestMarked,
    14 => productWithError,
    15 => readBleeding,
    16 => correspondentBanking,
    17 => saleMovementScanntechLoad,
    18 => sendData,
    _ => throw FormatException(
      'Unsupported synchronizer error detail type: $value',
    ),
  };
}
