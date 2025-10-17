import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shared/models/product_model.dart';
import '../../shared/models/cart_item_model.dart';

class OrderController extends GetxController {
  // Observable states
  final RxList<ProductModel> _allProducts = <ProductModel>[].obs;
  final RxList<ProductModel> _filteredProducts = <ProductModel>[].obs;
  final RxList<CartItemModel> _cartItems = <CartItemModel>[].obs;
  final RxList<String> _selectedCategories = <String>['Semua'].obs;
  final RxString _searchQuery = ''.obs;
  final RxBool _isLoading = false.obs;

  // Customer info
  final customerNameController = TextEditingController();
  final customerPhoneController = TextEditingController();
  final promoCodeController = TextEditingController();

  // Getters
  List<ProductModel> get filteredProducts => _filteredProducts;
  List<CartItemModel> get cartItems => _cartItems;
  List<String> get selectedCategories => _selectedCategories;
  int get cartItemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  bool get isLoading => _isLoading.value;
  
  // Check if a category is selected
  bool isCategorySelected(String category) {
    return _selectedCategories.contains(category);
  }

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
    
    // Mock data with real food images
    _allProducts.value = [
      ProductModel(
        id: '1',
        name: 'Nasi Goreng Spesial',
        description: 'Nasi goreng telur, baso, sosis, dadar telur',
        price: 19000,
        imageUrl: 'https://images.unsplash.com/photo-1603088775058-7c9cf0e43378?w=400&h=400&fit=crop',
        category: 'Makanan',
      ),
      ProductModel(
        id: '2',
        name: 'Tahu Asin Garam',
        description: 'Tahu goreng dengan bumbu garam',
        price: 14000,
        imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&h=400&fit=crop',
        category: 'Makanan',
      ),
      ProductModel(
        id: '3',
        name: 'Kopi Susu',
        description: 'Kopi susu gula aren',
        price: 15000,
        imageUrl: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400&h=400&fit=crop',
        category: 'Minuman Panas',
      ),
      ProductModel(
        id: '4',
        name: 'Es Teh Manis',
        description: 'Teh manis dingin segar',
        price: 8000,
        imageUrl: 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400&h=400&fit=crop',
        category: 'Minuman Dingin',
      ),
      ProductModel(
        id: '5',
        name: 'Pisang Goreng',
        description: 'Pisang goreng crispy',
        price: 10000,
        imageUrl: 'https://images.unsplash.com/photo-1587735243615-c03f25aaff15?w=400&h=400&fit=crop',
        category: 'Cemilan',
      ),
      ProductModel(
        id: '6',
        name: 'Mie Goreng',
        description: 'Mie goreng spesial dengan telur',
        price: 17000,
        imageUrl: 'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=400&h=400&fit=crop',
        category: 'Makanan',
      ),
      ProductModel(
        id: '7',
        name: 'Sate Ayam',
        description: 'Sate ayam bumbu kacang dengan lontong',
        price: 22000,
        imageUrl: 'https://images.unsplash.com/photo-1529563021893-cc83c992d75d?w=400&h=400&fit=crop',
        category: 'Makanan',
      ),
      ProductModel(
        id: '8',
        name: 'Cappuccino',
        description: 'Cappuccino dengan foam art premium',
        price: 18000,
        imageUrl: 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=400&h=400&fit=crop',
        category: 'Minuman Panas',
      ),
      ProductModel(
        id: '9',
        name: 'Es Jeruk',
        description: 'Jus jeruk segar dengan es batu',
        price: 12000,
        imageUrl: 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400&h=400&fit=crop',
        category: 'Minuman Dingin',
      ),
      ProductModel(
        id: '10',
        name: 'French Fries',
        description: 'Kentang goreng crispy dengan saus',
        price: 15000,
        imageUrl: 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=400&h=400&fit=crop',
        category: 'Cemilan',
      ),
      ProductModel(
        id: '11',
        name: 'Ayam Goreng Kremes',
        description: 'Ayam goreng dengan kremesan renyah',
        price: 25000,
        imageUrl: 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=400&h=400&fit=crop',
        category: 'Makanan',
      ),
      ProductModel(
        id: '12',
        name: 'Teh Tarik Panas',
        description: 'Teh tarik Malaysia yang creamy',
        price: 10000,
        imageUrl: 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=400&h=400&fit=crop',
        category: 'Minuman Panas',
      ),
      ProductModel(
        id: '13',
        name: 'Milkshake Coklat',
        description: 'Milkshake coklat dengan whipped cream',
        price: 20000,
        imageUrl: 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=400&h=400&fit=crop',
        category: 'Minuman Dingin',
      ),
      ProductModel(
        id: '14',
        name: 'Risoles Mayo',
        description: 'Risoles isi mayo, sayur, dan sosis',
        price: 8000,
        imageUrl: 'https://images.unsplash.com/photo-1509358271058-acd22cc93898?w=400&h=400&fit=crop',
        category: 'Cemilan',
      ),
      ProductModel(
        id: '15',
        name: 'Burger Ayam',
        description: 'Burger ayam crispy dengan keju dan sayuran',
        price: 28000,
        imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=400&fit=crop',
        category: 'Makanan',
      ),
    ];

    _filteredProducts.value = _allProducts;
    _isLoading.value = false;
  }

  // Category selection (multiple)
  void selectCategory(String category) {
    if (category == 'Semua') {
      // If "Semua" is clicked, clear all selections and select only "Semua"
      _selectedCategories.value = ['Semua'];
    } else {
      // Remove "Semua" if it's selected
      _selectedCategories.remove('Semua');
      
      // Toggle the category
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
        
        // If no categories are selected, default to "Semua"
        if (_selectedCategories.isEmpty) {
          _selectedCategories.add('Semua');
        }
      } else {
        _selectedCategories.add(category);
      }
    }
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
      // Check if product matches selected categories
      final matchesCategory = _selectedCategories.contains('Semua') ||
          _selectedCategories.contains(product.category);
      
      // Check if product matches search query
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
