// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vehicle _$VehicleFromJson(Map<String, dynamic> json) => Vehicle(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      make: json['make'] as String,
      model: json['model'] as String,
      year: (json['year'] as num).toInt(),
      color: json['color'] as String?,
      plateNumber: json['plateNumber'] as String,
      vinNumber: json['vinNumber'] as String?,
      mileage: (json['mileage'] as num?)?.toInt(),
      fuelType: json['fuelType'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$VehicleToJson(Vehicle instance) => <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'make': instance.make,
      'model': instance.model,
      'year': instance.year,
      'color': instance.color,
      'plateNumber': instance.plateNumber,
      'vinNumber': instance.vinNumber,
      'mileage': instance.mileage,
      'fuelType': instance.fuelType,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };