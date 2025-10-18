import 'package:uuid/uuid.dart';
import '../models/order.dart';

class OrderRepository {
  final Map<String, Order> _orders = {};
  final _uuid = const Uuid();
  int _orderCounter = 1;

  Future<Order> create(Order order) async {
    final orderNumber = 'ORD-${_orderCounter.toString().padLeft(6, '0')}';
    _orderCounter++;

    final newOrder = order.copyWith(
      id: _uuid.v4(),
      orderNumber: orderNumber,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _orders[newOrder.id] = newOrder;
    return newOrder;
  }

  Future<List<Order>> getAll({
    OrderStatus? status,
    String? customerPhone,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    var orders = _orders.values.toList();

    if (status != null) {
      orders = orders.where((o) => o.status == status).toList();
    }

    if (customerPhone != null) {
      orders = orders
          .where((o) => o.customerPhone.contains(customerPhone))
          .toList();
    }

    if (startDate != null) {
      orders = orders.where((o) => o.createdAt.isAfter(startDate)).toList();
    }

    if (endDate != null) {
      orders = orders.where((o) => o.createdAt.isBefore(endDate)).toList();
    }

    // Sort by creation date descending
    orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return orders;
  }

  Future<Order?> getById(String id) async {
    return _orders[id];
  }

  Future<Order?> getByOrderNumber(String orderNumber) async {
    try {
      return _orders.values.firstWhere(
        (o) => o.orderNumber == orderNumber,
      );
    } catch (e) {
      return null;
    }
  }

  Future<Order?> update(String id, Map<String, dynamic> data) async {
    final order = _orders[id];
    if (order == null) return null;

    final updatedOrder = order.copyWith(
      customerName: data['customerName'] ?? order.customerName,
      customerPhone: data['customerPhone'] ?? order.customerPhone,
      outletName: data['outletName'] ?? order.outletName,
      tableNumber: data['tableNumber'] ?? order.tableNumber,
      orderType: data['orderType'] ?? order.orderType,
      notes: data['notes'] ?? order.notes,
      updatedAt: DateTime.now(),
    );

    _orders[id] = updatedOrder;
    return updatedOrder;
  }

  Future<Order?> updateStatus(String id, OrderStatus status) async {
    final order = _orders[id];
    if (order == null) return null;

    final completedAt =
        status == OrderStatus.completed ? DateTime.now() : order.completedAt;

    final updatedOrder = order.copyWith(
      status: status,
      completedAt: completedAt,
      updatedAt: DateTime.now(),
    );

    _orders[id] = updatedOrder;
    return updatedOrder;
  }

  Future<bool> delete(String id) async {
    return _orders.remove(id) != null;
  }

  // Statistics
  Future<Map<String, dynamic>> getStatistics() async {
    final orders = _orders.values.toList();
    final total = orders.length;
    final pending = orders.where((o) => o.status == OrderStatus.pending).length;
    final processing =
        orders.where((o) => o.status == OrderStatus.processing).length;
    final completed =
        orders.where((o) => o.status == OrderStatus.completed).length;
    final cancelled =
        orders.where((o) => o.status == OrderStatus.cancelled).length;

    final totalRevenue = orders
        .where((o) => o.status == OrderStatus.completed)
        .fold<double>(0, (sum, o) => sum + o.total);

    return {
      'total': total,
      'pending': pending,
      'processing': processing,
      'completed': completed,
      'cancelled': cancelled,
      'totalRevenue': totalRevenue,
    };
  }
}
