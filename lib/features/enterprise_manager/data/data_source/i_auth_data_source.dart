import 'package:supabase_flutter/supabase_flutter.dart';

abstract class IManagerAuthRepository {
  Future<void> login(String email, String password);
  Future<void> logout();
  Stream<User?> get onAuthStateChange;
  User? getCurrentUser();
}
