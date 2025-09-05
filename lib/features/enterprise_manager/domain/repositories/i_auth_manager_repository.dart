import 'package:supabase_flutter/supabase_flutter.dart';

abstract class IAuthManagerRepository {
  Future<void> login(String email, String password);
  Future<void> logout();
  Stream<User?> get onAuthStateChange;
  User? getCurrentUser();
}
