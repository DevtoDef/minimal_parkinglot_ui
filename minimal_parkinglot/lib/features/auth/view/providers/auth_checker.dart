import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:minimal_parkinglot/core/providers/current_user_provider.dart';
import 'package:minimal_parkinglot/features/auth/model/user_model.dart';
import 'package:minimal_parkinglot/features/auth/repositories/auth_local_repository.dart';
import 'package:minimal_parkinglot/features/auth/repositories/auth_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_checker.g.dart';

@riverpod
Future<UserModel?> authChecker(Ref ref) async {
  final AuthLocalRepository authLocalRepository = ref.watch(
    authLocalRepositoryProvider,
  );
  final AuthRemoteRepository authRemoteRepository = ref.watch(
    authRemoteRepositoryProvider,
  );
  final CurrentUserNotifier currentUserProvider = ref.watch(
    currentUserNotifierProvider.notifier,
  );
  AsyncValue<UserModel> getUserDataSuccess(UserModel user) {
    authLocalRepository.setToken(user.accessToken);
    currentUserProvider.setUser(user);
    return AsyncData(user);
  }

  final String? token = authLocalRepository.getToken();
  if (token == null) {
    // No token found, user is not authenticated
    return null;
  }
  // If token exists, we can try to fetch the user data
  final res = await authRemoteRepository.getCurrentUserData(token);
  print("AuthChecker: $res");
  final val = switch (res) {
    Left(value: final l) =>
      AsyncError(l.message, StackTrace.current) as AsyncValue<UserModel?>,
    Right(value: final r) => getUserDataSuccess(r),
  };
  print("AuthChecker: $val");
  return val.value;
}
