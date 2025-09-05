import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/data_source/data_source.dart';
import '../../domain/repositories/repositories.dart';

class AuthManagerRepositoryImpl implements IAuthManagerRepository {
  final IAuthManagerDataSource dataSource;

  AuthManagerRepositoryImpl(this.dataSource);

  @override
  User? getCurrentUser() {
    return dataSource.getCurrentUser();
  }

  @override
  Future<void> login(String email, String password) {
    return dataSource.login(email, password);
  }

  @override
  Future<void> logout() {
    return dataSource.logout();
  }

  @override
  Stream<User?> get onAuthStateChange {
    return dataSource.onAuthStateChange;
  }
}
