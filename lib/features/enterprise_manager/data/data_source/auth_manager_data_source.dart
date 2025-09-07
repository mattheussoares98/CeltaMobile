import 'package:supabase_flutter/supabase_flutter.dart';
import 'data_source.dart';

class AuthManagerDataSource implements IAuthManagerDataSource {
  final SupabaseClient supabase;

  AuthManagerDataSource(this.supabase);

  @override
  User? getCurrentUser() {
    //TODO create tests
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
  Stream<User?> get onAuthStateChange =>
      supabase.auth.onAuthStateChange.map((event) => event.session?.user);
}
