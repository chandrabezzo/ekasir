import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shared/models/order_model.dart';
import '../../shared/models/order_status.dart';
import '../../shared/models/order_item_model.dart';
import '../../shared/models/product_model.dart';
import 'dart:math';

class DashboardController extends GetxController {
  // Observable states
  final RxList<OrderModel> _allOrders = <OrderModel>[].obs;
  final RxString _selectedTab = 'all'.obs;
  final RxBool _isLoading = false.obs;
  final RxInt _pendingCount = 0.obs;
  final RxInt _preparingCount = 0.obs;

  // Getters
  List<OrderModel> get allOrders => _allOrders;
  String get selectedTab => _selectedTab.value;
  bool get isLoading => _isLoading.value;
  int get pendingCount => _pendingCount.value;
  int get preparingCount => _preparingCount.value;

  // Filtered orders based on selected tab
  List<OrderModel> get filteredOrders {
    switch (_selectedTab.value) {
      case 'pending':
        return _allOrders.where((o) => o.status == OrderStatus.pending).toList();
      case 'preparing':
        return _allOrders.where((o) => o.status == OrderStatus.preparing).toList();
      case 'ready':
        return _allOrders.where((o) => o.status == OrderStatus.ready).toList();
      case 'completed':
        return _allOrders.where((o) => o.status == OrderStatus.completed).toList();
      default:
        return _allOrders.where((o) => 
          o.status != OrderStatus.completed && 
          o.status != OrderStatus.cancelled
        ).toList();
    }
  }

  // Statistics
  double get todayRevenue {
    final today = DateTime.now();
    return _allOrders
        .where((order) =>
            order.status == OrderStatus.completed &&
            order.createdAt.year == today.year &&
            order.createdAt.month == today.month &&
            order.createdAt.day == today.day)
        .fold(0.0, (sum, order) => sum + order.total);
  }

  int get todayOrderCount {
    final today = DateTime.now();
    return _allOrders
        .where((order) =>
            order.createdAt.year == today.year &&
            order.createdAt.month == today.month &&
            order.createdAt.day == today.day)
        .length;
  }

  @override
  void onInit() {
    super.onInit();
    _loadMockOrders();
    _updateCounts();
  }

  // Load mock orders (replace with API call in production)
  void _loadMockOrders() {
    _isLoading.value = true;

    // Create mock orders
    _allOrders.value = [
      _createMockOrder(
        orderNumber: 'ORD-001',
        customerName: 'Ahmad Yani',
        customerPhone: '081234567890',
        status: OrderStatus.pending,
        minutesAgo: 2,
      ),
      _createMockOrder(
        orderNumber: 'ORD-002',
        customerName: 'Siti Nurhaliza',
        customerPhone: '081234567891',
        status: OrderStatus.preparing,
        minutesAgo: 15,
      ),
      _createMockOrder(
        orderNumber: 'ORD-003',
        customerName: 'Budi Santoso',
        customerPhone: '081234567892',
        status: OrderStatus.ready,
        minutesAgo: 25,
      ),
      _createMockOrder(
        orderNumber: 'ORD-004',
        customerName: 'Rina Wijaya',
        customerPhone: '081234567893',
        status: OrderStatus.pending,
        minutesAgo: 5,
      ),
      _createMockOrder(
        orderNumber: 'ORD-005',
        customerName: 'Joko Widodo',
        customerPhone: '081234567894',
        status: OrderStatus.completed,
        minutesAgo: 60,
      ),
    ];

    _isLoading.value = false;
    _updateCounts();
  }

  OrderModel _createMockOrder({
    required String orderNumber,
    required String customerName,
    required String customerPhone,
    required OrderStatus status,
    required int minutesAgo,
  }) {
    final random = Random();
    final products = [
      ProductModel(
        id: '1',
        name: 'Nasi Goreng Spesial',
        description: 'Nasi goreng telur, baso, sosis',
        price: 19000,
        category: 'Makanan',
      ),
      ProductModel(
        id: '2',
        name: 'Kopi Susu',
        description: 'Kopi susu gula aren',
        price: 15000,
        category: 'Minuman',
      ),
      ProductModel(
        id: '3',
        name: 'Es Teh Manis',
        description: 'Teh manis dingin',
        price: 8000,
        category: 'Minuman',
      ),
    ];

    // Random 1-3 items
    final itemCount = random.nextInt(3) + 1;
    final items = List.generate(itemCount, (index) {
      final product = products[random.nextInt(products.length)];
      final quantity = random.nextInt(2) + 1;
      return OrderItemModel(
        id: 'item_${index + 1}',
        product: product,
        quantity: quantity,
        price: product.price,
        notes: index == 0 ? 'Tanpa bawang' : null,
      );
    });

    final subtotal = items.fold(0.0, (sum, item) => sum + item.totalPrice);
    final tax = subtotal * 0.1;
    final discount = 0.0;
    final total = subtotal + tax - discount;

    return OrderModel(
      id: 'order_${orderNumber.split('-')[1]}',
      orderNumber: orderNumber,
      items: items,
      customerName: customerName,
      customerPhone: customerPhone,
      subtotal: subtotal,
      tax: tax,
      discount: discount,
      total: total,
      status: status,
      createdAt: DateTime.now().subtract(Duration(minutes: minutesAgo)),
      completedAt: status == OrderStatus.completed
          ? DateTime.now().subtract(Duration(minutes: minutesAgo - 5))
          : null,
    );
  }

  void _updateCounts() {
    _pendingCount.value =
        _allOrders.where((o) => o.status == OrderStatus.pending).length;
    _preparingCount.value =
        _allOrders.where((o) => o.status == OrderStatus.preparing).length;
  }

  // Select tab
  void selectTab(String tab) {
    _selectedTab.value = tab;
  }

  // Update order status
  Future<bool> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      _isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      final index = _allOrders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _allOrders[index] = _allOrders[index].copyWith(
          status: newStatus,
          completedAt: newStatus == OrderStatus.completed
              ? DateTime.now()
              : _allOrders[index].completedAt,
        );
        _allOrders.refresh();
        _updateCounts();

        Get.snackbar(
          'Berhasil',
          'Status pesanan diperbarui',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        return true;
      }

      _isLoading.value = false;
      return false;
    } catch (e) {
      _isLoading.value = false;
      Get.snackbar(
        'Error',
        'Gagal memperbarui status',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  // Accept order (pending -> preparing)
  Future<bool> acceptOrder(String orderId) async {
    return await updateOrderStatus(orderId, OrderStatus.preparing);
  }

  // Mark as ready (preparing -> ready)
  Future<bool> markAsReady(String orderId) async {
    return await updateOrderStatus(orderId, OrderStatus.ready);
  }

  // Complete order (ready -> completed)
  Future<bool> completeOrder(String orderId) async {
    return await updateOrderStatus(orderId, OrderStatus.completed);
  }

  // Cancel order
  Future<bool> cancelOrder(String orderId) async {
    return await updateOrderStatus(orderId, OrderStatus.cancelled);
  }

  // Refresh orders
  Future<void> refreshOrders() async {
    _loadMockOrders();
  }

  // Get order by ID
  OrderModel? getOrderById(String orderId) {
    try {
      return _allOrders.firstWhere((o) => o.id == orderId);
    } catch (e) {
      return null;
    }
  }
}
