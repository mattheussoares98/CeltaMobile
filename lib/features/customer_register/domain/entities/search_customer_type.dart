enum SearchCustomerType {
  exactCnpjCpfNumber(1),
  exactCode(2),
  approximateName(3),
  personalizedCode(4);

  final int code;
  const SearchCustomerType(this.code);
}
