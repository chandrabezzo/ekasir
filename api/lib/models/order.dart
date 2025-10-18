import 'order_item.dart';

enum OrderStatus {
  pending,
  processing,
  completed,
  cancelled,
}

class Order {
  final String id;
  final String orderNumber;
  final List<OrderItem> items;
  final String customerName;
  final String customerPhone;
  final String? outletName;
  final String? tableNumber;
  final String? orderType;
  final double subtotal;
  final double tax;
  final double discount;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;
  final String? notes;

  Order({
    required this.id,
    required this.orderNumber,
    required this.items,
    required this.customerName,
    required this.customerPhone,
    this.outletName,
    this.tableNumber,
    this.orderType,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
    this.notes,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      orderNumber: json['orderNumber'] as String,
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
      outletName: json['outletName'] as String?,
      tableNumber: json['tableNumber'] as String?,
      orderType: json['orderType'] as String?,
      subtotal: (json['subtotal'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'items': items.map((item) => item.toJson()).toList(),
      'customerName': customerName,
      'customerPhone': customerPhone,
      'outletName': outletName,
      'tableNumber': tableNumber,
      'orderType': orderType,
      'subtotal': subtotal,
      'tax': tax,
      'discount': discount,
      'total': total,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'notes': notes,
    };
  }

  Order copyWith({
    String? id,
    String? orderNumber,
    List<OrderItem>? items,
    String? customerName,
    String? customerPhone,
    String? outletName,
    String? tableNumber,
    String? orderType,
    double? subtotal,
    double? tax,
    double? discount,
    double? total,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
    String? notes,
  }) {
    return Order(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      items: items ?? this.items,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      outletName: outletName ?? this.outletName,
      tableNumber: tableNumber ?? this.tableNumber,
      orderType: orderType ?? this.orderType,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
    );
  }
}
