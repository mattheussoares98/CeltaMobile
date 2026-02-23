import 'package:flutter/material.dart';

enum Status {
  usedByAnotherEntry("Utilizado por uma entrada (Finalizado)", Colors.red, [1]),
  canceled("Cancelado (Finalizado)", Colors.red, [2]),
  countingProducts("Efetuando contagem de produtos", Colors.green, [7]),
  liberatedForEntry(
    "Liberado para entrada (Aguardando entrada)",
    Colors.green,
    [3],
  ),
  inProcessOfAuthorization("Em processo de autorização", Colors.blue, [4]),
  awaitingMaintenanceOfProducts(
    "Aguardando manutenção de produtos",
    Colors.purple,
    [5, 6],
  ),
  awaitingEntryLiberation("Agua rdando liberação para entrada", Colors.black, [
    8,
  ]),
  unknownStatus("Status desconhecido. Avise o suporte", Colors.red, [0]);

  final String description;
  final Color color;
  final List<int> codes;

  const Status(this.description, this.color, this.codes);

  static Status fromCode(int code) {
    return Status.values.firstWhere(
      (status) => status.codes.contains(code),
      orElse: () => Status.unknownStatus,
    );
  }
}
