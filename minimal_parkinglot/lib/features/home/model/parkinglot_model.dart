// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ParkinglotModel {
  final String id;
  final String name;
  final String address;
  final int maxSpaces;
  final int currentSpaces;
  ParkinglotModel({
    required this.id,
    required this.name,
    required this.address,
    required this.maxSpaces,
    required this.currentSpaces,
  });

  ParkinglotModel copyWith({
    String? id,
    String? name,
    String? address,
    int? maxSpaces,
    int? currentSpaces,
  }) {
    return ParkinglotModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      maxSpaces: maxSpaces ?? this.maxSpaces,
      currentSpaces: currentSpaces ?? this.currentSpaces,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'address': address,
      'maxSpaces': maxSpaces,
      'currentSpaces': currentSpaces,
    };
  }

  factory ParkinglotModel.fromMap(Map<String, dynamic> map) {
    return ParkinglotModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      maxSpaces: map['maxspace'] ?? 0,
      currentSpaces: map['currentspace'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ParkinglotModel.fromJson(String source) =>
      ParkinglotModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ParkinglotModel(id: $id, name: $name, address: $address, maxSpaces: $maxSpaces, currentSpaces: $currentSpaces)';
  }

  @override
  bool operator ==(covariant ParkinglotModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.address == address &&
        other.maxSpaces == maxSpaces &&
        other.currentSpaces == currentSpaces;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        address.hashCode ^
        maxSpaces.hashCode ^
        currentSpaces.hashCode;
  }
}
