class PrintLabelEan13Encoder {
  const PrintLabelEan13Encoder();

  static const _leftOdd = <String>[
    '0001101',
    '0011001',
    '0010011',
    '0111101',
    '0100011',
    '0110001',
    '0101111',
    '0111011',
    '0110111',
    '0001011',
  ];
  static const _leftEven = <String>[
    '0100111',
    '0110011',
    '0011011',
    '0100001',
    '0011101',
    '0111001',
    '0000101',
    '0010001',
    '0001001',
    '0010111',
  ];
  static const _right = <String>[
    '1110010',
    '1100110',
    '1101100',
    '1000010',
    '1011100',
    '1001110',
    '1010000',
    '1000100',
    '1001000',
    '1110100',
  ];
  static const _parities = <String>[
    'LLLLLL',
    'LLGLGG',
    'LLGGLG',
    'LLGGGL',
    'LGLLGG',
    'LGGLLG',
    'LGGGLL',
    'LGLGLG',
    'LGLGGL',
    'LGGLGL',
  ];

  String? encode(String value) {
    if (!RegExp(r'^\d{13}$').hasMatch(value) || !_hasValidChecksum(value)) {
      return null;
    }

    final firstDigit = int.parse(value[0]);
    final parity = _parities[firstDigit];
    final result = StringBuffer('101');

    for (var index = 1; index <= 6; index++) {
      final digit = int.parse(value[index]);
      result.write(
        parity[index - 1] == 'L' ? _leftOdd[digit] : _leftEven[digit],
      );
    }

    result.write('01010');
    for (var index = 7; index <= 12; index++) {
      result.write(_right[int.parse(value[index])]);
    }
    result.write('101');
    return result.toString();
  }

  bool _hasValidChecksum(String value) {
    var sum = 0;
    for (var index = 0; index < 12; index++) {
      final digit = int.parse(value[index]);
      sum += index.isEven ? digit : digit * 3;
    }
    return (10 - (sum % 10)) % 10 == int.parse(value[12]);
  }
}
