enum EcSendDataType {
  sale(1),
  customer(2),
  employee(3);

  final int value;

  const EcSendDataType(this.value);

  factory EcSendDataType.fromValue(int value) {
    switch (value) {
      case 1:
        return EcSendDataType.sale;
      case 2:
        return EcSendDataType.customer;
      case 3:
        return EcSendDataType.employee;
      default:
        return EcSendDataType.sale;
    }
  }

  factory EcSendDataType.fromErrorKey(String errorKey) {
    if (errorKey.contains('envio de vendas')) {
      return EcSendDataType.sale;
    } else if (errorKey.contains('envio de clientes')) {
      return EcSendDataType.customer;
    } else {
      return EcSendDataType.employee;
    }
  }
}
