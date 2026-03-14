class CancelToken {
  final String name;
  CancelToken(this.name);

  bool _isCancelled = false;
  bool get isCancelled => _isCancelled;
  void cancel() => _isCancelled = true;
}
