// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CarItemHiveModel {
  int productsId;
  int productsQTY;
  double unitPrice;
  String productsName;
  String productsImage;
  String serviceName;
  CarItemHiveModel({
    required this.productsId,
    required this.productsQTY,
    required this.unitPrice,
    required this.productsName,
    required this.productsImage,
    required this.serviceName,
  });

  CarItemHiveModel copyWith({
    int? productsId,
    int? productsQTY,
    double? unitPrice,
    String? productsName,
    String? productsImage,
    String? serviceName,
  }) {
    return CarItemHiveModel(
      productsId: productsId ?? this.productsId,
      productsQTY: productsQTY ?? this.productsQTY,
      unitPrice: unitPrice ?? this.unitPrice,
      productsName: productsName ?? this.productsName,
      productsImage: productsImage ?? this.productsImage,
      serviceName: serviceName ?? this.serviceName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productsId': productsId,
      'productsQTY': productsQTY,
      'unitPrice': unitPrice,
      'productsName': productsName,
      'productsImage': productsImage,
      'serviceName': serviceName,
    };
  }

  factory CarItemHiveModel.fromMap(Map<String, dynamic> map) {
    return CarItemHiveModel(
      productsId: map['productsId'] as int,
      productsQTY: map['productsQTY'] as int,
      unitPrice: map['unitPrice'] as double,
      productsName: map['productsName'] as String,
      productsImage: map['productsImage'] as String,
      serviceName: map['serviceName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CarItemHiveModel.fromJson(String source) =>
      CarItemHiveModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CarItemHiveModel(productsId: $productsId, productsQTY: $productsQTY, unitPrice: $unitPrice, productsName: $productsName, productsImage: $productsImage, serviceName: $serviceName)';
  }

  @override
  bool operator ==(covariant CarItemHiveModel other) {
    if (identical(this, other)) return true;

    return other.productsId == productsId &&
        other.productsQTY == productsQTY &&
        other.unitPrice == unitPrice &&
        other.productsName == productsName &&
        other.productsImage == productsImage &&
        other.serviceName == serviceName;
  }

  @override
  int get hashCode {
    return productsId.hashCode ^
        productsQTY.hashCode ^
        unitPrice.hashCode ^
        productsName.hashCode ^
        productsImage.hashCode ^
        serviceName.hashCode;
  }
}
