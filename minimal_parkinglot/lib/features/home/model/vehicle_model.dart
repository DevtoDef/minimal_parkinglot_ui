// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

class VehicleModel {
  final int id;
  final String checkInImages;
  final String nfc_card_id;
  final String license_plate;
  final DateTime? checkInTime;
  VehicleModel({
    required this.id,
    required this.checkInImages,
    required this.nfc_card_id,
    required this.license_plate,
    required this.checkInTime,
  });

  VehicleModel copyWith({
    int? id,
    String? checkInImages,
    String? nfc_card_id,
    String? license_plate,
    DateTime? checkInTime,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      checkInImages: checkInImages ?? this.checkInImages,
      nfc_card_id: nfc_card_id ?? this.nfc_card_id,
      license_plate: license_plate ?? this.license_plate,
      checkInTime: checkInTime ?? this.checkInTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'checkInImages': checkInImages,
      'nfc_card_id': nfc_card_id,
      'license_plate': license_plate,
      'checkInTime': checkInTime?.millisecondsSinceEpoch,
    };
  }

  factory VehicleModel.fromMap(Map<String, dynamic> map) {
    return VehicleModel(
      id: map['id'] ?? '',
      checkInImages: map['checkInImages'] ?? '',
      nfc_card_id: map['nfc_card_id'] ?? '',
      license_plate: map['license_plate'] ?? '',
      checkInTime:
          map['checkInTime'] == null
              ? null
              : DateTime.parse(map['checkInTime'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory VehicleModel.fromJson(String source) =>
      VehicleModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VehicleModel(id: $id, checkInImages: $checkInImages, nfc_card_id: $nfc_card_id, license_plate: $license_plate, checkInTime: $checkInTime)';
  }

  @override
  bool operator ==(covariant VehicleModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.checkInImages == checkInImages &&
        other.nfc_card_id == nfc_card_id &&
        other.license_plate == license_plate &&
        other.checkInTime == checkInTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        checkInImages.hashCode ^
        nfc_card_id.hashCode ^
        license_plate.hashCode ^
        checkInTime.hashCode;
  }
}
