import 'package:minimal_parkinglot/features/auth/model/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_provider.g.dart';

@Riverpod(keepAlive: true)
class CurrentUserNotifier extends _$CurrentUserNotifier {
  @override
  UserModel? build() {
    return null; // Initially, no user is logged in.
  }

  void setUser(UserModel user) {
    state = user; // Update the current user.
  }

  void clearUser() {
    state = null; // Clear the current user.
  }
}
