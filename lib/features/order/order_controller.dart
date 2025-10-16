import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shared/models/product_model.dart';
import '../../shared/models/cart_item_model.dart';

class OrderController extends GetxController {
  // Observable states
  final RxList<ProductModel> _allProducts = <ProductModel>[].obs;
  final RxList<ProductModel> _filteredProducts = <ProductModel>[].obs;
  final RxList<CartItemModel> _cartItems = <CartItemModel>[].obs;
  final RxString _selectedCategory = 'Semua'.obs;
  final RxString _searchQuery = ''.obs;
  final RxBool _isLoading = false.obs;

  // Customer info
  final customerNameController = TextEditingController();
  final customerPhoneController = TextEditingController();
  final promoCodeController = TextEditingController();

  // Getters
  List<ProductModel> get filteredProducts => _filteredProducts;
  List<CartItemModel> get cartItems => _cartItems;
  String get selectedCategory => _selectedCategory.value;
  int get cartItemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  bool get isLoading => _isLoading.value;

  // Categories
  final List<String> categories = [
    'Semua',
    'Makanan',
    'Cemilan',
    'Minuman Panas',
    'Minuman Dingin',
  ];

  // Cart calculations
  double get subtotal =>
      _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  
  double get tax => subtotal * 0.1; // 10% tax
  
  double get discount => 0.0; // Can be calculated based on promo code
  
  double get total => subtotal + tax - discount;

  @override
  void onInit() {
    super.onInit();
    _loadMockProducts();
  }

  @override
  void onClose() {
    customerNameController.dispose();
    customerPhoneController.dispose();
    promoCodeController.dispose();
    super.onClose();
  }

  // Load mock products (replace with API call in production)
  void _loadMockProducts() {
    _isLoading.value = true;
    
    // Mock data based on the images
    _allProducts.value = [
      ProductModel(
        id: '1',
        name: 'Nasi Goreng Spesial',
        description: 'Nasi goreng telur, baso, sosis, dadar telur',
        price: 19000,
        imageUrl: 'https://via.placeholder.com/150',
        category: 'Makanan',
      ),
      ProductModel(
        id: '2',
        name: 'Tahu Asin Garam',
        description: 'Tahu goreng dengan bumbu garam',
        price: 14000,
        imageUrl: 'https://via.placeholder.com/150',
        category: 'Makanan',
      ),
      ProductModel(
        id: '3',
        name: 'Kopi Susu',
        description: 'Kopi susu gula aren',
        price: 15000,
        imageUrl: 'https://via.placeholder.com/150',
        category: 'Minuman Panas',
      ),
      ProductModel(
        id: '4',
        name: 'Es Teh Manis',
        description: 'Teh manis dingin segar',
        price: 8000,
        imageUrl: 'https://via.placeholder.com/150',
        category: 'Minuman Dingin',
      ),
      ProductModel(
        id: '5',
        name: 'Pisang Goreng',
        description: 'Pisang goreng crispy',
        price: 10000,
        imageUrl: 'https://via.placeholder.com/150',
        category: 'Cemilan',
      ),
      ProductModel(
        id: '6',
        name: 'Mie Goreng',
        description: 'Mie goreng spesial dengan telur',
        price: 17000,
        imageUrl: 'https://via.placeholder.com/150',
        category: 'Makanan',
      ),
    ];

    _filteredProducts.value = _allProducts;
    _isLoading.value = false;
  }

  // Category selection
  void selectCategory(String category) {
    _selectedCategory.value = category;
    _filterProducts();
  }

  // Search
  void search(String query) {
    _searchQuery.value = query;
    _filterProducts();
  }

  // Filter products based on category and search
  void _filterProducts() {
    var products = _allProducts.where((product) {
      final matchesCategory = _selectedCategory.value == 'Semua' ||
          product.category == _selectedCategory.value;
      final matchesSearch = _searchQuery.value.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery.value.toLowerCase()) ||
          product.description.toLowerCase().contains(_searchQuery.value.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    _filteredProducts.value = products;
  }

  // Add to cart
  void addToCart(ProductModel product, int quantity, String? notes) {
    final existingIndex = _cartItems.indexWhere(
      (item) => item.product.id == product.id && item.notes == notes,
    );

    if (existingIndex != -1) {
      _cartItems[existingIndex].quantity += quantity;
      _cartItems.refresh();
    } else {
      _cartItems.add(CartItemModel(
        product: product,
        quantity: quantity,
        notes: notes,
      ));
    }

    Get.snackbar(
      'Berhasil',
      '${product.name} ditambahkan ke keranjang',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Update cart item quantity
  void updateCartItemQuantity(int index, int quantity) {
    if (quantity <= 0) {
      _cartItems.removeAt(index);
    } else {
      _cartItems[index].quantity = quantity;
      _cartItems.refresh();
    }
  }

  // Remove from cart
  void removeFromCart(int index) {
    _cartItems.removeAt(index);
  }

  // Clear cart
  void clearCart() {
    _cartItems.clear();
    customerNameController.clear();
    customerPhoneController.clear();
    promoCodeController.clear();
  }

  // Place order
  Future<bool> placeOrder() async {
    if (_cartItems.isEmpty) {
      Get.snackbar(
        'Error',
        'Keranjang masih kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (customerNameController.text.isEmpty ||
        customerPhoneController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Mohon isi nama dan nomor HP',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    _isLoading.value = true;

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // In production, send order to backend
    // await orderService.createOrder(...)

    _isLoading.value = false;
    return true;
  }
}
