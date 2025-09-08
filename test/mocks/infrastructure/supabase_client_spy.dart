import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Listener<T> extends Mock {
  void call(T? previous, T next);
}

class _FakePostgrestFilterBuilder<T> extends Fake
    implements PostgrestFilterBuilder<T> {
  final Future<T> _future;
  _FakePostgrestFilterBuilder(this._future);

  @override
  PostgrestFilterBuilder<T> eq(String column, dynamic value) => this;

  @override
  Future<R> then<R>(
    FutureOr<R> Function(T value) onValue, {
    Function? onError,
  }) {
    return _future.then(onValue, onError: onError);
  }
}

class _FakeSupabaseQueryBuilder extends Fake implements SupabaseQueryBuilder {
  final Future<List<Map<String, dynamic>>> _future;
  _FakeSupabaseQueryBuilder(this._future);

  @override
  PostgrestFilterBuilder<List<Map<String, dynamic>>> select([
    String columns = '*',
  ]) {
    return _FakePostgrestFilterBuilder(_future);
  }
}

class SupabaseClientSpy extends Fake implements SupabaseClient {
  dynamic _rpcReturnValue;
  Object? _rpcErrorToThrow;

  void mockResponse(dynamic data) {
    _rpcReturnValue = data;
    _rpcErrorToThrow = null;
  }

  void mockFromError(Object error) {
    _rpcErrorToThrow = error;
    _rpcReturnValue = null;
  }

  @override
  SupabaseQueryBuilder from(String table) {
    if (_rpcErrorToThrow != null) {
      return _FakeSupabaseQueryBuilder(Future.error(_rpcErrorToThrow!));
    }
    return _FakeSupabaseQueryBuilder(Future.value(_rpcReturnValue));
  }

  final List<Map<String, dynamic>> rpcCallHistory = [];
  String? get lastRpcFunction =>
      rpcCallHistory.isNotEmpty ? rpcCallHistory.last['fn'] as String? : null;
  Map<String, dynamic>? get lastRpcParams => rpcCallHistory.isNotEmpty
      ? rpcCallHistory.last['params'] as Map<String, dynamic>?
      : null;

  @override
  PostgrestFilterBuilder<T> rpc<T>(
    String fn, {
    Map<String, dynamic>? params,
    dynamic get = false,
  }) {
    rpcCallHistory.add({'fn': fn, 'params': params});
    if (_rpcErrorToThrow != null) {
      final error = _rpcErrorToThrow!;
      _rpcErrorToThrow = null;
      return _FakePostgrestFilterBuilder<T>(Future.error(error));
    }
    final future = Future.value(_rpcReturnValue as T);
    return _FakePostgrestFilterBuilder<T>(future);
  }
}
