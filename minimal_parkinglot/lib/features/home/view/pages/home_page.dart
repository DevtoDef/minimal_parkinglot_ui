import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimal_parkinglot/core/providers/current_user_provider.dart';
import 'package:minimal_parkinglot/core/theme/app_pallete.dart';
import 'package:minimal_parkinglot/features/auth/view/pages/login_page.dart';
import 'package:minimal_parkinglot/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:minimal_parkinglot/features/home/view/pages/parkinglot_page.dart';
import 'package:minimal_parkinglot/features/home/view/widgets/action_button.dart';
import 'package:minimal_parkinglot/features/home/viewmodel/home_viewmodel.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);
    final parkingLots = ref.watch(fetchParkingLotsProvider);
    return parkingLots.when(
      data: (data) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Trang Chủ',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Pallete.whiteColor,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Pallete.whiteColor),
                onPressed: () async {
                  // Gọi hàm logout từ ViewModel
                  await ref.read(authViewmodelProvider.notifier).logout();

                  // Sau khi logout thành công, điều hướng về trang Login
                  // và xóa tất cả các trang cũ khỏi stack
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                      (route) => false,
                    );
                  }
                },
              ),
            ],
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome ${currentUser?.username ?? 'User'}!',
                    style: TextStyle(fontSize: 20, color: Pallete.whiteColor),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Danh sách bãi xe',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Pallete.gradient1,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Danh sách các nút hành động cho các bãi xe
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final parkingLot = data[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ActionButton(
                            label: parkingLot.name,
                            subtitle: 'Địa chỉ: ${parkingLot.address}',
                            onTap: () {
                              // Xử lý khi người dùng nhấn vào nút
                              // Ví dụ: điều hướng đến trang chi tiết bãi xe
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ParkinglotPage(
                                        parkinglot: parkingLot,
                                      ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        // Xử lý dữ liệu bãi xe
      },
      loading: () {
        // Hiển thị loading
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
      error: (error, stack) {
        // Xử lý lỗi
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $error')));
        });
        return const Scaffold(
          body: Center(child: Text('Đã xảy ra lỗi. Vui lòng thử lại.')),
        );
      },
    );
  }
}
