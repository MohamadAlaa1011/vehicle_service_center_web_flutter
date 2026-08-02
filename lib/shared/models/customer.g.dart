// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      address: json['address'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

PaginatedCustomers _$PaginatedCustomersFromJson(Map<String, dynamic> json) =>
    PaginatedCustomers(
      data: (json['data'] as List<dynamic>)
          .map((e) => Customer.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: PaginationMeta.fromJson(json as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaginatedCustomersToJson(
        PaginatedCustomers instance) =>
    <String, dynamic>{
      'data': instance.data,
      'meta': instance.meta,
    };

PaginationMeta _$PaginationMetaFromJson(Map<String, dynamic> json) =>
    PaginationMeta(
      page: json['page'] as int,
      limit: json['limit'] as int,
      total: json['total'] as int,
      totalPages: json['totalPages'] as int,
      hasNextPage: json['hasNextPage'] as bool,
      hasPrevPage: json['hasPrevPage'] as bool,
    );

Map<String, dynamic> _$PaginationMetaToJson(PaginationMeta instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'total': instance.total,
      'totalPages': instance.totalPages,
      'hasNextPage': instance.hasNextPage,
      'hasPrevPage': instance.hasPrevPage,
    };