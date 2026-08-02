import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer {
  final String id;
  final String fullName;
  final String phone;
  final String? email;
  final String? address;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  Customer({
    required this.id,
    required this.fullName,
    required this.phone,
    this.email,
    this.address,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}

class PaginatedCustomers {
  final List<Customer> data;
  final PaginationMeta meta;
  
  PaginatedCustomers({
    required this.data,
    required this.meta,
  });
  
  factory PaginatedCustomers.fromJson(Map<String, dynamic> json) {
    return PaginatedCustomers(
      data: (json['data'] as List<dynamic>)
          .map((e) => Customer.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}

class PaginationMeta {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;
  
  PaginationMeta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });
  
  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      hasNextPage: json['hasNextPage'] as bool? ?? false,
      hasPrevPage: json['hasPrevPage'] as bool? ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'totalPages': totalPages,
      'hasNextPage': hasNextPage,
      'hasPrevPage': hasPrevPage,
    };
  }
}