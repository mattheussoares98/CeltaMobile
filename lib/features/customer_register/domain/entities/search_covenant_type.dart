enum SearchCovenantType {
  exactCnpjNumber(1),
  exactCode(2),
  approximateName(3);

  final int code;
  const SearchCovenantType(this.code);
}
