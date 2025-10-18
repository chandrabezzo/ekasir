import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/models/product_model.dart';

class MenuManagementController extends GetxController {
  final RxList<ProductModel> _menus = <ProductModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _searchQuery = ''.obs;
  final RxString _selectedCategory = 'all'.obs;

  List<ProductModel> get menus => _menus;
  bool get isLoading => _isLoading.value;
  String get searchQuery => _searchQuery.value;
  String get selectedCategory => _selectedCategory.value;

  // Categories
  final List<String> categories = [
    'all',
    'Food',
    'Beverage',
    'Snack',
    'Dessert',
  ];

  // Filtered menus based on search and category
  List<ProductModel> get filteredMenus {
    var filtered = _menus.toList();

    // Filter by category
    if (_selectedCategory.value != 'all') {
      filtered = filtered
          .where((menu) => menu.category == _selectedCategory.value)
          .toList();
    }

    // Filter by search query
    if (_searchQuery.value.isNotEmpty) {
      filtered = filtered
          .where((menu) =>
              menu.name.toLowerCase().contains(_searchQuery.value.toLowerCase()) ||
              menu.description.toLowerCase().contains(_searchQuery.value.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  @override
  void onInit() {
    super.onInit();
    _loadMenus();
  }

  // Load menus from storage/API
  Future<void> _loadMenus() async {
    _isLoading.value = true;

    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock data - Replace with actual API call
      _menus.value = [
        ProductModel(
          id: '1',
          name: 'Nasi Goreng Spesial',
          description: 'Nasi goreng dengan telur, ayam, dan sayuran',
          price: 25000,
          category: 'Food',
          imageUrl: 'https://via.placeholder.com/150',
          isAvailable: true,
        ),
        ProductModel(
          id: '2',
          name: 'Mie Goreng',
          description: 'Mie goreng dengan topping ayam dan sayuran',
          price: 20000,
          category: 'Food',
          imageUrl: 'https://via.placeholder.com/150',
          isAvailable: true,
        ),
        ProductModel(
          id: '3',
          name: 'Es Teh Manis',
          description: 'Teh manis dingin segar',
          price: 5000,
          category: 'Beverage',
          imageUrl: 'https://via.placeholder.com/150',
          isAvailable: true,
        ),
        ProductModel(
          id: '4',
          name: 'Kopi Hitam',
          description: 'Kopi hitam original tanpa gula',
          price: 10000,
          category: 'Beverage',
          imageUrl: 'https://via.placeholder.com/150',
          isAvailable: true,
        ),
        ProductModel(
          id: '5',
          name: 'Kentang Goreng',
          description: 'Kentang goreng crispy dengan saus',
          price: 15000,
          category: 'Snack',
          imageUrl: 'https://via.placeholder.com/150',
          isAvailable: true,
        ),
        ProductModel(
          id: '6',
          name: 'Es Krim Vanilla',
          description: 'Es krim vanilla premium',
          price: 12000,
          category: 'Dessert',
          imageUrl: 'https://via.placeholder.com/150',
          isAvailable: false,
        ),
      ];
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat menu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Search menus
  void searchMenus(String query) {
    _searchQuery.value = query;
  }

  // Filter by category
  void filterByCategory(String category) {
    _selectedCategory.value = category;
  }

  // Add new menu
  Future<bool> addMenu(ProductModel menu) async {
    _isLoading.value = true;

    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 800));

      _menus.add(menu);

      Get.snackbar(
        'Berhasil',
        'Menu berhasil ditambahkan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      _isLoading.value = false;
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menambahkan menu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      _isLoading.value = false;
      return false;
    }
  }

  // Update existing menu
  Future<bool> updateMenu(ProductModel menu) async {
    _isLoading.value = true;

    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 800));

      final index = _menus.indexWhere((m) => m.id == menu.id);
      if (index != -1) {
        _menus[index] = menu;
        _menus.refresh();

        Get.snackbar(
          'Berhasil',
          'Menu berhasil diperbarui',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        _isLoading.value = false;
        return true;
      } else {
        throw Exception('Menu tidak ditemukan');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memperbarui menu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      _isLoading.value = false;
      return false;
    }
  }

  // Delete menu
  Future<bool> deleteMenu(String menuId) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      _menus.removeWhere((menu) => menu.id == menuId);

      Get.snackbar(
        'Berhasil',
        'Menu berhasil dihapus',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus menu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  // Toggle menu availability
  Future<void> toggleAvailability(String menuId) async {
    final index = _menus.indexWhere((m) => m.id == menuId);
    if (index != -1) {
      final menu = _menus[index];
      final updatedMenu = ProductModel(
        id: menu.id,
        name: menu.name,
        description: menu.description,
        price: menu.price,
        category: menu.category,
        imageUrl: menu.imageUrl,
        isAvailable: !menu.isAvailable,
      );

      _menus[index] = updatedMenu;
      _menus.refresh();

      Get.snackbar(
        'Berhasil',
        updatedMenu.isAvailable
            ? 'Menu ${menu.name} tersedia'
            : 'Menu ${menu.name} tidak tersedia',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: updatedMenu.isAvailable ? Colors.green : Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Refresh menus
  Future<void> refreshMenus() async {
    await _loadMenus();
  }

  // Get menu by ID
  ProductModel? getMenuById(String id) {
    try {
      return _menus.firstWhere((menu) => menu.id == id);
    } catch (e) {
      return null;
    }
  }
}
