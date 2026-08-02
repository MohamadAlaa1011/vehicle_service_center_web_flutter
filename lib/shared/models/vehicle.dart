import 'package:json_annotation/json_annotation.dart';

part 'vehicle.g.dart';

@JsonSerializable()
class Vehicle {
  final String id;
  final String customerId;
  final String make;
  final String model;
  final int year;
  final String? color;
  final String plateNumber;
  final String? vinNumber;
  final int? mileage;
  final String? fuelType;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  Vehicle({
    required this.id,
    required this.customerId,
    required this.make,
    required this.model,
    required this.year,
    this.color,
    required this.plateNumber,
    this.vinNumber,
    this.mileage,
    this.fuelType,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory Vehicle.fromJson(Map<String, dynamic> json) => _$VehicleFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleToJson(this);
  
  String get displayName => '$year $make $model';
  String get displayMileage => mileage != null ? '${mileage!.toStringAsFixed(0)} miles' : 'Unknown';
}