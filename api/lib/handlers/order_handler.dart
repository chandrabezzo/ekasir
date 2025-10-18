import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../repositories/order_repository.dart';
import '../utils/response_helper.dart';
import '../models/order.dart';
import '../models/order_item.dart';

class OrderHandler {
  final OrderRepository orderRepository;

  OrderHandler(this.orderRepository);

  Router get router {
    final router = Router();

    router.get('/', _getAll);
    router.get('/statistics', _getStatistics);
    router.get('/<id>', _getById);
    router.post('/', _create);
    router.put('/<id>', _update);
    router.put('/<id>/status', _updateStatus);
    router.delete('/<id>', _delete);

    return router;
  }

  Future<Response> _getAll(Request request) async {
    try {
      final statusStr = request.url.queryParameters['status'];
      final customerPhone = request.url.queryParameters['customerPhone'];
      final startDateStr = request.url.queryParameters['startDate'];
      final endDateStr = request.url.queryParameters['endDate'];

      OrderStatus? status;
      if (statusStr != null) {
        status = OrderStatus.values.firstWhere(
          (e) => e.name == statusStr,
          orElse: () => OrderStatus.pending,
        );
      }

      DateTime? startDate;
      if (startDateStr != null) {
        startDate = DateTime.parse(startDateStr);
      }

      DateTime? endDate;
      if (endDateStr != null) {
        endDate = DateTime.parse(endDateStr);
      }

      final orders = await orderRepository.getAll(
        status: status,
        customerPhone: customerPhone,
        startDate: startDate,
        endDate: endDate,
      );

      return ResponseHelper.success(data: orders.map((o) => o.toJson()).toList());
    } catch (e) {
      return ResponseHelper.internalError(e.toString());
    }
  }

  Future<Response> _getById(Request request, String id) async {
    try {
      final order = await orderRepository.getById(id);

      if (order == null) {
        return ResponseHelper.notFound('Order not found');
      }

      return ResponseHelper.success(data: order.toJson());
    } catch (e) {
      return ResponseHelper.internalError(e.toString());
    }
  }

  Future<Response> _create(Request request) async {
    try {
      final body = await request.readAsString();
      final data = json.decode(body) as Map<String, dynamic>;

      final customerName = data['customerName'] as String?;
      final customerPhone = data['customerPhone'] as String?;
      final itemsData = data['items'] as List?;

      if (customerName == null || customerPhone == null || itemsData == null) {
        return ResponseHelper.badRequest(
            'Customer name, phone, and items are required');
      }

      final items = itemsData
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList();

      if (items.isEmpty) {
        return ResponseHelper.badRequest('Order must have at least one item');
      }

      final subtotal = data['subtotal'] as num? ?? 0;
      final tax = data['tax'] as num? ?? 0;
      final discount = data['discount'] as num? ?? 0;
      final total = data['total'] as num? ?? 0;

      final newOrder = Order(
        id: '',
        orderNumber: '',
        items: items,
        customerName: customerName,
        customerPhone: customerPhone,
        outletName: data['outletName'] as String?,
        tableNumber: data['tableNumber'] as String?,
        orderType: data['orderType'] as String?,
        subtotal: subtotal.toDouble(),
        tax: tax.toDouble(),
        discount: discount.toDouble(),
        total: total.toDouble(),
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        notes: data['notes'] as String?,
      );

      final order = await orderRepository.create(newOrder);

      return ResponseHelper.success(
        data: order.toJson(),
        message: 'Order created successfully',
        statusCode: 201,
      );
    } catch (e) {
      return ResponseHelper.internalError(e.toString());
    }
  }

  Future<Response> _update(Request request, String id) async {
    try {
      final body = await request.readAsString();
      final data = json.decode(body) as Map<String, dynamic>;

      final order = await orderRepository.update(id, data);

      if (order == null) {
        return ResponseHelper.notFound('Order not found');
      }

      return ResponseHelper.success(
        data: order.toJson(),
        message: 'Order updated successfully',
      );
    } catch (e) {
      return ResponseHelper.internalError(e.toString());
    }
  }

  Future<Response> _updateStatus(Request request, String id) async {
    try {
      final body = await request.readAsString();
      final data = json.decode(body) as Map<String, dynamic>;

      final statusStr = data['status'] as String?;

      if (statusStr == null) {
        return ResponseHelper.badRequest('Status is required');
      }

      final status = OrderStatus.values.firstWhere(
        (e) => e.name == statusStr,
        orElse: () => OrderStatus.pending,
      );

      final order = await orderRepository.updateStatus(id, status);

      if (order == null) {
        return ResponseHelper.notFound('Order not found');
      }

      return ResponseHelper.success(
        data: order.toJson(),
        message: 'Order status updated successfully',
      );
    } catch (e) {
      return ResponseHelper.internalError(e.toString());
    }
  }

  Future<Response> _delete(Request request, String id) async {
    try {
      final deleted = await orderRepository.delete(id);

      if (!deleted) {
        return ResponseHelper.notFound('Order not found');
      }

      return ResponseHelper.success(message: 'Order cancelled successfully');
    } catch (e) {
      return ResponseHelper.internalError(e.toString());
    }
  }

  Future<Response> _getStatistics(Request request) async {
    try {
      final stats = await orderRepository.getStatistics();

      return ResponseHelper.success(data: stats);
    } catch (e) {
      return ResponseHelper.internalError(e.toString());
    }
  }
}
