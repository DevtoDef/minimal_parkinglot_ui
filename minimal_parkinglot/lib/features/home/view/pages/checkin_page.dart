import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minimal_parkinglot/core/theme/app_pallete.dart';
import 'package:minimal_parkinglot/features/auth/view/widgets/gradient_button.dart';
import 'package:minimal_parkinglot/features/auth/view/widgets/loader.dart';
import 'package:minimal_parkinglot/features/auth/view/widgets/utils.dart';
import 'package:minimal_parkinglot/features/home/model/vehicle_model.dart';
import 'package:minimal_parkinglot/features/home/view/widgets/nfc_dialog.dart';
import 'package:minimal_parkinglot/features/home/viewmodel/home_viewmodel.dart';

class CheckInPage extends ConsumerStatefulWidget {
  final String parkinglotId;
  const CheckInPage({super.key, required this.parkinglotId});

  @override
  ConsumerState<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends ConsumerState<CheckInPage> {
  File? _imageFile;
  final TextEditingController _licensePlateController = TextEditingController();

  // Hàm để chọn ảnh từ camera hoặc thư viện
  Future<void> _pickImage(ImageSource source) async {
    try {
      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      if (mounted) showSnackBar(context, 'Lỗi khi chọn ảnh: $e');
    }
  }

  void _handleConfirm() {
    if (_imageFile == null) {
      showSnackBar(context, 'Vui lòng chụp ảnh xe!');
      return;
    }
    // Chỉ cần gọi hàm trong ViewModel, ref.listen sẽ xử lý phần còn lại
    ref
        .read(homeViewmodelProvider.notifier)
        .addNewVehicle(
          checkInImages: _imageFile!,
          license_plate: _licensePlateController.text,
          parkingLotId: widget.parkinglotId,
        );
  }

  @override
  void dispose() {
    _licensePlateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      homeViewmodelProvider.select((val) => val?.isLoading == true),
    );
    ref.listen(homeViewmodelProvider, (_, next) {
      next?.when(
        data: (VehicleModel vehicle) {
          showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (_) => NfcWriteDialog(dataToWrite: vehicle.nfc_card_id),
          ).then((isSuccess) {
            // Sau khi dialog đóng, kiểm tra kết quả
            if (isSuccess == true) {
              // Nếu ghi thẻ thành công, LÀM MỚI DỮ LIỆU và QUAY VỀ
              ref.invalidate(
                fetchParkingLotsProvider,
              ); // Làm mới danh sách bãi xe
              if (mounted) {
                showSnackBar(
                  context,
                  'Check-in thành công!',
                  backgroundColor: Colors.green,
                );
                Navigator.of(context).pop();
              }
            } else {
              // Nếu ghi thẻ thất bại hoặc người dùng hủy
              if (mounted)
                showSnackBar(
                  context,
                  'Ghi thẻ NFC đã bị hủy.',
                  backgroundColor: Colors.orange,
                );
            }
          });
        },
        error:
            (error, stackTrace) => showSnackBar(
              context,
              error.toString(),
              backgroundColor: Colors.red,
            ),
        loading: () {},
      );
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Check In Xe',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body:
          isLoading
              ? const Loader()
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Khung hiển thị ảnh hoặc nút chọn ảnh
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Pallete.gradient1.withOpacity(0.8),
                          width: 2,
                        ),
                      ),
                      child:
                          _imageFile == null
                              ? _buildImagePicker()
                              : ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.file(
                                  _imageFile!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                    ),
                    const SizedBox(height: 30),

                    // Ô nhập biển số xe
                    Text(
                      'Thông tin xe',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Nhập biển số xe (tùy chọn)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Pallete.gradient1,
                            width: 2,
                          ),
                        ),
                      ),
                      controller: _licensePlateController,
                    ),
                    const SizedBox(height: 40),

                    // Nút xác nhận
                    GradientButton(
                      buttonText: 'Xác nhận & Ghi thẻ NFC',
                      onTap: _handleConfirm,
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Chụp ảnh xe vào',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Pallete.whiteColor,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Nút chụp ảnh từ Camera
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Camera'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Pallete.gradient2,
                foregroundColor: Pallete.whiteColor,
              ),
            ),
            const SizedBox(width: 20),
            // Nút chọn ảnh từ Thư viện
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo_library),
              label: const Text('Thư viện'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Pallete.gradient1,
                foregroundColor: Pallete.whiteColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
