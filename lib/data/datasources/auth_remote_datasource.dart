import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/errors/exceptions.dart';
import '../../core/utils/logger.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> signup(String email, String password);
  Future<void> logout();
  Future<UserModel> getCurrentUser();
  Stream<AuthState> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserModel> login(String email, String password) async {
    bluePrint('➡️ AuthRemoteDetailSource: Logging in user: $email');
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw ServerException(message: 'Login failed: User is null');
      }
      greenPrint(
        '✅ AuthRemoteDetailSource: Login successful for user: ${response.user!.email}',
      );
      return UserModel(
        id: response.user!.id,
        email: response.user!.email ?? '',
      );
    } catch (e) {
      redPrint('❌ AuthRemoteDetailSource: Login failed: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signup(String email, String password) async {
    bluePrint('➡️ AuthRemoteDetailSource: Signing up user: $email');
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw ServerException(message: 'Signup failed: User is null');
      }
      greenPrint(
        '✅ AuthRemoteDetailSource: Signup successful for user: ${response.user!.email}',
      );
      return UserModel(
        id: response.user!.id,
        email: response.user!.email ?? '',
      );
    } catch (e) {
      redPrint('❌ AuthRemoteDetailSource: Signup failed: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> logout() async {
    bluePrint('➡️ AuthRemoteDetailSource: Logging out');
    try {
      await supabaseClient.auth.signOut();
      greenPrint('✅ AuthRemoteDetailSource: Logout successful');
    } catch (e) {
      redPrint('❌ AuthRemoteDetailSource: Logout failed: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    bluePrint('➡️ AuthRemoteDetailSource: Getting current user');
    final user = supabaseClient.auth.currentUser;
    if (user != null) {
      greenPrint('✅ AuthRemoteDetailSource: Current user found: ${user.email}');
      return UserModel(id: user.id, email: user.email ?? '');
    } else {
      redPrint('❌ AuthRemoteDetailSource: No user logged in');
      throw ServerException(message: 'No user logged in');
    }
  }

  @override
  Stream<AuthState> get authStateChanges =>
      supabaseClient.auth.onAuthStateChange;
}
