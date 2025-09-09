import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../exceptions/exceptions.dart';
import '../core/domain/errors/errors.dart';
import '../localization/string_hardcoded.dart';

mixin ErrorHandling {
  AsyncError<T> getAsyncError<T>(Object error, StackTrace st) {
    late final String message;

    if (error is PostgrestException) {
      message = error.message;
    } else if (error is AppException) {
      message = error.message;
    } else if (error is BsError) {
      message = error.message;
    } else {
      message = error.toString();
    }

    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('timed out') ||
        lowerMessage.contains('failed host')) {
      return AsyncError(
        'Erro de conexão. Verifique a sua internet'.hardcoded,
        st,
      );
    } else if (lowerMessage.contains('invalid login credentials')) {
      return AsyncError(
        'Credenciais de login inválidas. Por favor, verifique seu e-mail e senha.'
            .hardcoded,
        st,
      );
    } else if (lowerMessage.contains(
      'password should be at least 6 characters',
    )) {
      return AsyncError(
        'A senha deve ter pelo menos 6 caracteres.'.hardcoded,
        st,
      );
    } else if (lowerMessage.contains('user already registered')) {
      return AsyncError('Este e-mail já está cadastrado.'.hardcoded, st);
    } else if (lowerMessage.contains('unable to validate email address')) {
      return AsyncError('Formato de e-mail inválido.'.hardcoded, st);
    } else if (lowerMessage.contains('you can only request this after')) {
      return AsyncError(
        'Essa ação está bloqueada temporariamente. Tente novamente daqui a pouco.'
            .hardcoded,
        st,
      );
    }
    return AsyncError(message, st);
  }
}
