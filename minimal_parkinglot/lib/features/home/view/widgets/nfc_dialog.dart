import 'package:flutter/material.dart';
import 'package:minimal_parkinglot/core/theme/app_pallete.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

class NfcWriteDialog extends StatefulWidget {
  final String dataToWrite;
  const NfcWriteDialog({super.key, required this.dataToWrite});

  @override
  State<NfcWriteDialog> createState() => _NfcWriteDialogState();
}

class _NfcWriteDialogState extends State<NfcWriteDialog> {
  String _message = 'Vui lòng đưa thẻ NFC vào gần điện thoại...';
  IconData _icon = Icons.nfc;
  Color _iconColor = Pallete.gradient2;

  @override
  void initState() {
    super.initState();
    _startNfcWriting();
  }

  void _startNfcWriting() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) {
      setState(() {
        _message = 'NFC không khả dụng trên thiết bị này.';
        _icon = Icons.error;
        _iconColor = Colors.red;
      });
      return;
    }

    NfcManager.instance.startSession(
      alertMessage: "Đưa thẻ NFC lại gần điện thoại để ghi dữ liệu",
      onDiscovered: (NfcTag tag) async {
        try {
          var ndef = Ndef.from(tag);

          if (ndef == null) {
            // Thẻ không hỗ trợ NDEF, nhưng có thể format được
            await _formatAndWrite(tag, widget.dataToWrite);
            return;
          }

          // === BƯỚC KIỂM TRA DỮ LIỆU HIỆN TẠI ===
          if (ndef.cachedMessage != null &&
              ndef.cachedMessage!.records.isNotEmpty) {
            final record = ndef.cachedMessage!.records.first;
            if (record.typeNameFormat == NdefTypeNameFormat.nfcWellknown &&
                record.type.first == 0x54) {
              final messagePayload = record.payload;
              final languageCodeLength = messagePayload.first & 0x3F;
              final existingMessage = String.fromCharCodes(
                messagePayload.sublist(1 + languageCodeLength),
              );

              print('Đọc được message từ thẻ: $existingMessage');

              // Kiểm tra nếu thẻ đã có nfc_card_id (không phải TEST)
              if (existingMessage != 'TEST OK! ' &&
                  existingMessage.isNotEmpty) {
                _updateStateOnError(
                  'Thẻ này đã có dữ liệu. Vui lòng dùng thẻ trắng.',
                );
                return;
              }

              // Nếu là thẻ TEST, tiến hành ghi đè
              if (existingMessage == 'TEST OK!') {
                print('Phát hiện thẻ test, tiến hành ghi đè...');
                await _writeToCard(ndef, widget.dataToWrite);
                return;
              }
            }
          }
          // === KẾT THÚC BƯỚC KIỂM TRA ===

          // Thẻ trống hoặc không có dữ liệu NDEF
          await _writeToCard(ndef, widget.dataToWrite);
        } catch (e) {
          _updateStateOnError('Lỗi khi ghi thẻ: $e');
        }
      },
    );
  }

  // Hàm ghi dữ liệu vào thẻ NDEF
  Future<void> _writeToCard(Ndef ndef, String data) async {
    // Kiểm tra thẻ có thể ghi không
    if (!ndef.isWritable) {
      _updateStateOnError('Thẻ này không thể ghi (chỉ đọc)');
      return;
    }

    // Ghi dữ liệu vào thẻ
    NdefMessage message = NdefMessage([NdefRecord.createText(data)]);
    await ndef.write(message);
    _updateStateOnSuccess('Ghi thẻ thành công!');
  }

  // Format thẻ trắng và ghi dữ liệu
  Future<void> _formatAndWrite(NfcTag tag, String data) async {
    var ndefFormatable = NdefFormatable.from(tag);
    if (ndefFormatable != null) {
      print('Formatting blank tag...');
      NdefMessage message = NdefMessage([NdefRecord.createText(data)]);
      await ndefFormatable.format(message);
      _updateStateOnSuccess('Đã format và ghi thẻ thành công!');
    } else {
      _updateStateOnError('Thẻ này không hỗ trợ ghi dữ liệu');
    }
  }

  void _updateStateOnSuccess(String message) {
    setState(() {
      _message = message;
      _icon = Icons.check_circle;
      _iconColor = Colors.green;
    });
    NfcManager.instance.stopSession(alertMessage: message);
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) Navigator.of(context).pop(true);
    });
  }

  void _updateStateOnError(String message) {
    setState(() {
      _message = message;
      _icon = Icons.error;
      _iconColor = Colors.red;
    });
    NfcManager.instance.stopSession(errorMessage: message);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Pallete.backgroundColor.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, color: _iconColor, size: 70),
          const SizedBox(height: 24),
          Text(
            _message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Hủy', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }
}
