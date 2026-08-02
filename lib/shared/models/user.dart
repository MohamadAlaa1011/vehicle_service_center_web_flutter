import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
  
  bool get isAdmin => role == 'SUPER_ADMIN';
  bool get isManager => role == 'SERVICE_MANAGER';
  bool get isMechanic => role == 'MECHANIC';
  bool get isReceptionist => role == 'RECEPTIONIST';
  
  String get displayRole {
    switch (role) {
      case 'SUPER_ADMIN':
        return 'Super Admin';
      case 'SERVICE_MANAGER':
        return 'Service Manager';
      case 'MECHANIC':
        return 'Mechanic';
      case 'RECEPTIONIST':
        return 'Receptionist';
      default:
        return role;
    }
  }
}