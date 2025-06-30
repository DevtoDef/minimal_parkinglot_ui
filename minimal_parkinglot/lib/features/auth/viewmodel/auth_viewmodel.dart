import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:minimal_parkinglot/core/providers/current_user_provider.dart';
import 'package:minimal_parkinglot/features/auth/model/user_model.dart';
import 'package:minimal_parkinglot/features/auth/repositories/auth_local_repository.dart';
import 'package:minimal_parkinglot/features/auth/repositories/auth_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewmodel extends _$AuthViewmodel {
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;
  late CurrentUserNotifier _currentUserProvider;
  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _currentUserProvider = ref.watch(currentUserNotifierProvider.notifier);

    return null;
  }

  Future<void> signup({
    required String email,
    required String username,
    required String password,
  }) async {
    // Implement signup logic here
    state = const AsyncLoading();
    final res = await _authRemoteRepository.signup(
      email: email,
      username: username,
      password: password,
    );
    final val = switch (res) {
      Left(value: final l) => state = AsyncError(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncData(r),
    };
    print(val);
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    // Implement signup logic here
    state = const AsyncLoading();
    final res = await _authRemoteRepository.login(
      username: username,
      password: password,
    );
    final val = switch (res) {
      Left(value: final l) => state = AsyncError(l.message, StackTrace.current),
      Right(value: final r) => _loginSuccess(r),
    };
    print(val);
  }

  AsyncValue<UserModel>? _loginSuccess(UserModel user) {
    _authLocalRepository.setToken(user.accessToken);
    _currentUserProvider.setUser(user);
    return state = AsyncData(user);
  }

  //Khi user restart the app, we will get the current user data from the remote repository
  Future<UserModel?> getCurrentUserData() async {
    // Fetch the current user data from the remote repository
    state = const AsyncLoading();
    final accessToken = _authLocalRepository.getToken();
    if (accessToken != null) {
      final res = await _authRemoteRepository.getCurrentUserData(accessToken);
      final val = switch (res) {
        Left(value: final l) =>
          state = AsyncError(l.message, StackTrace.current),
        Right(value: final r) => _getCurrentUserDataSuccess(r),
      };
      return val.value;
    } else {
      return null;
    }
  }

  AsyncValue<UserModel> _getCurrentUserDataSuccess(UserModel user) {
    _currentUserProvider.setUser(user);
    return state = AsyncData(user);
  }

  Future<void> logout() async {
    // Implement logout logic here
    state = const AsyncLoading();
    await _authLocalRepository.clearToken();
    _currentUserProvider.clearUser();
    state = null;
  }
}
