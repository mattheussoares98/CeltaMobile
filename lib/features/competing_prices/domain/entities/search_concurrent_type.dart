enum SearchConcurrentType {
  exactCode(1),
  approximateName(2);

  final int code;
  const SearchConcurrentType(this.code);
}
