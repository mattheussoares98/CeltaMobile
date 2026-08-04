enum BSFProductWithErrorType {
  error(1),
  markedToSendAgain(2),
  markedToIgnoreError(3);

  final int value;

  const BSFProductWithErrorType(this.value);

  static BSFProductWithErrorType fromValue(int value) => switch (value) {
    1 => error,
    2 => markedToSendAgain,
    3 => markedToIgnoreError,
    _ => throw FormatException('Unsupported product-with-error type: $value'),
  };
}
