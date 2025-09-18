import 'package:supabase_flutter/supabase_flutter.dart';

abstract class IAuthManagerDatasource {
  Future<AuthResponse> login(String email, String password);
  Future<void> logout();
  Stream<User?> get onAuthStateChange;
  User? getCurrentUser();
}
