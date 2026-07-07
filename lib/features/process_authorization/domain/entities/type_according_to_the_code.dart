import 'dart:developer' as console;

enum TypeAccordingToTheCode {
  receiptLiberateDocument(3),
  saleRequestLucrativity(4),
  saleRequestDiscount(7);

  final int code;
  const TypeAccordingToTheCode(this.code);

  static TypeAccordingToTheCode? fromCode(int code) {
    try {
      return TypeAccordingToTheCode.values.firstWhere((e) => e.code == code);
    } catch (error) {
      console.log(
        "######################"
        "Tipo de erro não encontrado para o código: $code"
        "######################",
      );
      return null;
    }
  }
}
