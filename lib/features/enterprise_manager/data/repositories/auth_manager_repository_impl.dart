import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:celta_inventario/features/enterprise_manager/data/datasource/datasource.dart';
import 'package:celta_inventario/features/enterprise_manager/domain/repositories/repositories.dart';

class AuthManagerRepositoryImpl implements IAuthManagerRepository {
  final IAuthManagerDatasource dataSource;

  AuthManagerRepositoryImpl(this.dataSource);

  @override
  User? getCurrentUser() {
    return dataSource.getCurrentUser();
  }

  @override
  Future<AuthResponse> login(String email, String password) {
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
