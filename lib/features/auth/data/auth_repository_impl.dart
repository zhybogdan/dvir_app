import 'dart:io';

import 'package:dvir/core/config/supabase_providers.dart';
import 'package:dvir/core/error/failures.dart';
import 'package:dvir/features/auth/data/auth_repository.dart';
import 'package:dvir/features/auth/domain/models/app_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

part 'auth_repository_impl.g.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._client);

  final sb.SupabaseClient _client;

  AppUser? _mapUser(sb.User? user) =>
      user == null ? null : AppUser(id: user.id, email: user.email ?? '');

  @override
  AppUser? get currentUser => _mapUser(_client.auth.currentUser);

  @override
  Stream<AppUser?> authStateChanges() => _client.auth.onAuthStateChange.map(
    (event) => _mapUser(event.session?.user),
  );

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
    } on sb.AuthException catch (e) {
      throw AuthFailure(e.message);
    } on SocketException {
      throw const NetworkFailure();
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    try {
      await _client.auth.signUp(email: email, password: password);
    } on sb.AuthException catch (e) {
      throw AuthFailure(e.message);
    } on SocketException {
      throw const NetworkFailure();
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } on sb.AuthException catch (e) {
      throw AuthFailure(e.message);
    }
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    AuthRepositoryImpl(ref.watch(supabaseClientProvider));
