import 'package:celta_inventario/core/domain/errors/errors.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/extensions/string_modifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

String parseErrorMessage(Object? error) {
  late final String message;
  String? supabaseDetails;

  if (error is PostgrestException) {
    message = error.message;
    supabaseDetails = error.details.toString();
  } else if (error is AppException) {
    message = error.message;
  } else if (error is BsError) {
    message = error.message;
  } else if (error is Exception) {
    message = error.toString().replaceFirst('Exception: ', '');
  } else {
    message = error.toString();
  }

  final lowerMessage = message.toLowerCase();

  if (lowerMessage.contains('timed out') || lowerMessage.contains('timeout')) {
    return 'Tempo limite atingido. Por favor, tente novamente.'.hardcoded;
  } else if (lowerMessage.contains('failed host')) {
    return 'Erro de conexão. Verifique a sua internet.'.hardcoded;
  } else if (lowerMessage.contains('invalid login credentials')) {
    return 'Credenciais de login inválidas. Por favor, verifique seu e-mail e senha.'
        .hardcoded;
  } else if (lowerMessage.contains(
    'password should be at least 6 characters',
  )) {
    return 'A senha deve ter pelo menos 6 caracteres.'.hardcoded;
  } else if (lowerMessage.contains('user already registered')) {
    return 'Este e-mail já está cadastrado.'.hardcoded;
  } else if (lowerMessage.contains('unable to validate email address')) {
    return 'Formato de e-mail inválido.'.hardcoded;
  } else if (lowerMessage.contains('you can only request this after')) {
    return 'Essa ação está bloqueada temporariamente. Tente novamente daqui a pouco.'
        .hardcoded;
  } else if (lowerMessage.contains('duplicate key value')) {
    return 'Essa ação está duplicando dados que não podem ser duplicados. \n$supabaseDetails'
        .hardcoded;
  } else if (lowerMessage.contains(
    "Closure: ([String?]) => HttpError from Function".toLowerCase(),
  )) {
    return 'O método não foi encontrado. Informe o suporte técnico que a API não está funcionando ou deve ser atualizada'
        .hardcoded;
  }
  return message.formatBreakLines();
}
