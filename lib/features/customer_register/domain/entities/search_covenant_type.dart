enum SearchCovenantType {
  exactCnpjNumber(1),
  exactCode(2),
  approximateName(2);

  final int code;
  const SearchCovenantType(this.code);
}
