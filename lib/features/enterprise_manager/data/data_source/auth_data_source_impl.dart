import 'package:supabase_flutter/supabase_flutter.dart';

import 'data_source.dart';

class ManagerAuthRepositoryImpl implements IManagerAuthRepository {
  final SupabaseClient supabase;

  ManagerAuthRepositoryImpl(this.supabase);

  @override
  User? getCurrentUser() {
    //TODO create tests
    return supabase.auth.currentUser;
  }

  @override
  Future<void> login(String email, String password) async {
    await supabase.auth.signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  @override
  Stream<User?> get onAuthStateChange =>
      supabase.auth.onAuthStateChange.map((event) => event.session?.user);
}
