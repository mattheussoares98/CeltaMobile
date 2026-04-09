enum OperationType {
  exit(2, 'Saída'),
  entrance(1, 'Entrada');

  final int value;
  final String name;
  const OperationType(this.value, this.name);
}
