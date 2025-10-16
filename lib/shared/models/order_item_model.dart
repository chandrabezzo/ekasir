import 'product_model.dart';

class OrderItemModel {
  final String id;
  final ProductModel product;
  final int quantity;
  final String? notes;
  final double price;

  OrderItemModel({
    required this.id,
    required this.product,
    required this.quantity,
    this.notes,
    required this.price,
  });

  double get totalPrice => price * quantity;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as String,
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      notes: json['notes'] as String?,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity,
      'notes': notes,
      'price': price,
    };
  }
}
