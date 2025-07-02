import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimal_parkinglot/core/theme/app_pallete.dart';
import 'package:minimal_parkinglot/features/auth/view/widgets/gradient_button.dart';
import 'package:minimal_parkinglot/features/auth/view/widgets/loader.dart';
import 'package:minimal_parkinglot/features/auth/view/widgets/utils.dart';
import 'package:minimal_parkinglot/features/home/model/vehicle_model.dart';
import 'package:minimal_parkinglot/features/home/view/widgets/info_row.dart';
import 'package:minimal_parkinglot/features/home/view/widgets/scanning_ui.dart';
import 'package:minimal_parkinglot/features/home/viewmodel/home_viewmodel.dart';
import 'package:nfc_manager/nfc_manager.dart';


class CheckOutPage extends ConsumerStatefulWidget {
  const CheckOutPage({super.key});

  @override
  ConsumerState<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends ConsumerState<CheckOutPage> {
  String? _nfcCardId;

  @override
  void initState() {
    super.initState();
    // Bắt đầu quét NFC ngay khi vào trang
    _startNFCScan();
  }

  Future<void> _startNFCScan() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) {
      if (mounted) {
        showSnackBar(
          context,
          'NFC không khả dụng trên thiết bị này.',
          backgroundColor: Colors.red,
        );
      }
      return; // Đảm bảo có return
    }

    try {
      await NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          try {
            final ndef = Ndef.from(tag);
            if (ndef == null) {
              if (mounted) {
                showSnackBar(context, 'Thẻ không hỗ trợ định dạng NDEF.');
              }
              return;
            }

            final record = ndef.cachedMessage?.records.first;
            if (record == null) {
              if (mounted) {
                showSnackBar(context, 'Thẻ không có dữ liệu.');
              }
              return;
            }

            final nfcId = String.fromCharCodes(record.payload).substring(3);

            await NfcManager.instance.stopSession();
            if (mounted) {
              setState(() {
                _nfcCardId = nfcId;
              });
            }
          } catch (e) {
            await NfcManager.instance.stopSession(
              errorMessage: "Lỗi khi đọc thẻ: $e",
            );
          }
        },
        onError: (error) async {
          if (mounted) {
            showSnackBar(context, 'Lỗi quét NFC: ${error.toString()}');
          }
          // Không cần return ở đây vì đây là callback
        },
      );
    } catch (e) {
      // Xử lý lỗi chung của startSession
      if (mounted) {
        showSnackBar(context, 'Lỗi khởi tạo phiên NFC: ${e.toString()}');
      }
    }
    // Hàm sẽ tự động return void ở đây
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Check Out Xe',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child:
            _nfcCardId == null
                ? buildScanningUI(title: 'Đang đợi thông tin từ thẻ của khách')
                : _VerificationView(nfcCardId: _nfcCardId!),
      ),
    );
  }
}

class _VerificationView extends ConsumerWidget {
  final String nfcCardId;
  const _VerificationView({required this.nfcCardId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch provider lấy thông tin xe và truyền ID vào
    final vehicleState = ref.watch(getVehicleByNFCProvider(nfcCardId));

    // Dùng when() để tự động xử lý các trạng thái
    return vehicleState.when(
      loading: () => const Loader(),
      error:
          (error, stackTrace) => Text(
            'Lỗi khi lấy thông tin xe: $error',
            style: const TextStyle(color: Colors.red),
          ),
      data: (vehicle) => _buildVerificationUI(context, vehicle),
    );
  }
}

Widget _buildVerificationUI(BuildContext context, VehicleModel vehicle) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        // Ảnh xe lúc vào - PHẦN QUAN TRỌNG NHẤT
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Pallete.gradient1.withOpacity(0.8),
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              vehicle.checkInImages,
              fit: BoxFit.cover,
              // Hiển thị loader trong lúc tải ảnh
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: Loader());
              },
              // Hiển thị icon lỗi nếu không tải được ảnh
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, color: Colors.red, size: 50);
              },
            ),
          ),
        ),
        const SizedBox(height: 30),

        // Thông tin chi tiết
        BuildInfoRow('Biển số xe:', vehicle.license_plate),
        const Divider(color: Pallete.borderColor),
        BuildInfoRow(
          'Thời gian vào:',
          '${vehicle.checkInTime!.hour}:${vehicle.checkInTime!.minute} - ${vehicle.checkInTime!.day}/${vehicle.checkInTime!.month}/${vehicle.checkInTime!.year}',
        ),

        const SizedBox(height: 40),

        // Nút xác nhận Check-out
        GradientButton(
          buttonText: 'Hoàn tất Check-Out',
          onTap: () {
            // TODO: Gọi ViewModel để xử lý logic Check-out
            print('Xác nhận Check-out');
          },
        ),
      ],
    ),
  );
}
