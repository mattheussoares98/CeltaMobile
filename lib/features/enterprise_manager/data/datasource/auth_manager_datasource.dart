import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:celta_inventario/features/enterprise_manager/data/datasource/datasource.dart';

class AuthManagerDatasource implements IAuthManagerDatasource {
  final SupabaseClient supabase;

  AuthManagerDatasource(this.supabase);

  @override
  User? getCurrentUser() {
    return supabase.auth.currentUser;
  }

  @override
  Future<AuthResponse> login(String email, String password) {
    return supabase.auth.signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> logout() {
    return supabase.auth.signOut();
  }

  @override
  Stream<User?> get onAuthStateChange => supabase.auth.onAuthStateChange
      .map((event) => event.session?.user)
      .distinct();
}
