enum BSFSendDataType {
  sale(1),
  customer(2),
  employee(3);

  final int value;

  const BSFSendDataType(this.value);

  factory BSFSendDataType.fromValue(int value) {
    switch (value) {
      case 1:
        return BSFSendDataType.sale;
      case 2:
        return BSFSendDataType.customer;
      case 3:
        return BSFSendDataType.employee;
      default:
        return BSFSendDataType.sale;
    }
  }

  factory BSFSendDataType.fromErrorKey(String errorKey) {
    if (errorKey.contains('envio de vendas')) {
      return BSFSendDataType.sale;
    } else if (errorKey.contains('envio de clientes')) {
      return BSFSendDataType.customer;
    } else {
      return BSFSendDataType.employee;
    }
  }
}
