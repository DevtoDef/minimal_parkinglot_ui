import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimal_parkinglot/core/providers/storage_provider.dart';
import 'package:minimal_parkinglot/features/auth/view/pages/login_page.dart';
import 'package:minimal_parkinglot/features/auth/view/providers/auth_checker.dart';
import 'package:minimal_parkinglot/features/auth/view/widgets/loader.dart';
import 'package:minimal_parkinglot/features/home/view/pages/home_page.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. LẮNG NGHE TRỰC TIẾP PROVIDER CẤP THẤP NHẤT (SharedPreferences)
    final storageState = ref.watch(sharedPreferencesProvider);

    // Dùng when() cho provider này để quyết định
    return storageState.when(
      // KHI SharedPreferences ĐANG TẢI -> HIỂN THỊ LOADER
      // Đây là lúc ngăn chặn lỗi của bạn xảy ra
      loading: () => const Scaffold(body: Loader()),

      // Nếu SharedPreferences lỗi không thể khởi tạo
      error:
          (error, stack) => Scaffold(
            body: Center(
              child: Text("Lỗi nghiêm trọng, không thể khởi động app: $error"),
            ),
          ),

      // KHI SharedPreferences ĐÃ SẴN SÀNG
      data: (sharedPreferences) {
        // Bây giờ, các provider khác như authLocalRepositoryProvider
        // có thể được truy cập một cách an toàn.
        // Chúng ta sẽ gọi đến provider cấp cao hơn là authCheckerProvider
        // để kiểm tra thông tin user.
        return const _UserStatusChecker();
      },
    );
  }
}

// Widget con này chỉ được build KHI SharedPreferences đã sẵn sàng
class _UserStatusChecker extends ConsumerWidget {
  const _UserStatusChecker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authCheckState = ref.watch(authCheckerProvider);
    print("AuthChecker: $authCheckState");

    return authCheckState.when(
      loading: () => const Scaffold(body: Loader()),
      error: (error, stack) {
        print("AuthChecker Error: $error");
        return const LoginPage();
      }, // Nếu API lỗi/token hết hạn -> về Login
      data: (user) {
        return user != null ? const HomePage() : const LoginPage();
      },
    );
  }
}
