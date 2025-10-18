import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/models/category_model.dart';

class CategoryManagementController extends GetxController {
  final RxList<CategoryModel> _categories = <CategoryModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _searchQuery = ''.obs;

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading.value;
  String get searchQuery => _searchQuery.value;

  // Get active categories only
  List<CategoryModel> get activeCategories {
    return _categories.where((cat) => cat.isActive).toList();
  }

  // Get category names for dropdown
  List<String> get categoryNames {
    return activeCategories.map((cat) => cat.name).toList();
  }

  // Filtered categories based on search
  List<CategoryModel> get filteredCategories {
    if (_searchQuery.value.isEmpty) {
      return _categories.toList();
    }

    return _categories
        .where((cat) =>
            cat.name.toLowerCase().contains(_searchQuery.value.toLowerCase()) ||
            cat.description.toLowerCase().contains(_searchQuery.value.toLowerCase()))
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    _loadCategories();
  }

  // Load categories from storage/API
  Future<void> _loadCategories() async {
    _isLoading.value = true;

    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock data - Replace with actual API call
      _categories.value = [
        CategoryModel(
          id: '1',
          name: 'Food',
          description: 'Makanan utama dan lauk pauk',
          iconName: 'restaurant',
          isActive: true,
        ),
        CategoryModel(
          id: '2',
          name: 'Beverage',
          description: 'Minuman panas dan dingin',
          iconName: 'local_cafe',
          isActive: true,
        ),
        CategoryModel(
          id: '3',
          name: 'Snack',
          description: 'Camilan dan makanan ringan',
          iconName: 'fastfood',
          isActive: true,
        ),
        CategoryModel(
          id: '4',
          name: 'Dessert',
          description: 'Makanan penutup dan pencuci mulut',
          iconName: 'cake',
          isActive: true,
        ),
      ];
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat kategori',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Search categories
  void searchCategories(String query) {
    _searchQuery.value = query;
  }

  // Add new category
  Future<bool> addCategory(CategoryModel category) async {
    _isLoading.value = true;

    try {
      // Check if category name already exists
      final exists = _categories.any(
        (cat) => cat.name.toLowerCase() == category.name.toLowerCase(),
      );

      if (exists) {
        Get.snackbar(
          'Peringatan',
          'Kategori dengan nama ini sudah ada',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        _isLoading.value = false;
        return false;
      }

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 800));

      _categories.add(category);

      Get.snackbar(
        'Berhasil',
        'Kategori berhasil ditambahkan',
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
        'Gagal menambahkan kategori',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      _isLoading.value = false;
      return false;
    }
  }

  // Update existing category
  Future<bool> updateCategory(CategoryModel category) async {
    _isLoading.value = true;

    try {
      // Check if new name conflicts with existing categories (excluding current)
      final exists = _categories.any(
        (cat) =>
            cat.id != category.id &&
            cat.name.toLowerCase() == category.name.toLowerCase(),
      );

      if (exists) {
        Get.snackbar(
          'Peringatan',
          'Kategori dengan nama ini sudah ada',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        _isLoading.value = false;
        return false;
      }

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 800));

      final index = _categories.indexWhere((cat) => cat.id == category.id);
      if (index != -1) {
        _categories[index] = category;
        _categories.refresh();

        Get.snackbar(
          'Berhasil',
          'Kategori berhasil diperbarui',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        _isLoading.value = false;
        return true;
      } else {
        throw Exception('Kategori tidak ditemukan');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memperbarui kategori',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      _isLoading.value = false;
      return false;
    }
  }

  // Delete category
  Future<bool> deleteCategory(String categoryId) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      _categories.removeWhere((cat) => cat.id == categoryId);

      Get.snackbar(
        'Berhasil',
        'Kategori berhasil dihapus',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus kategori',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  // Toggle category active status
  Future<void> toggleActive(String categoryId) async {
    final index = _categories.indexWhere((cat) => cat.id == categoryId);
    if (index != -1) {
      final category = _categories[index];
      final updatedCategory = category.copyWith(isActive: !category.isActive);

      _categories[index] = updatedCategory;
      _categories.refresh();

      Get.snackbar(
        'Berhasil',
        updatedCategory.isActive
            ? 'Kategori ${category.name} diaktifkan'
            : 'Kategori ${category.name} dinonaktifkan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: updatedCategory.isActive ? Colors.green : Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Refresh categories
  Future<void> refreshCategories() async {
    await _loadCategories();
  }

  // Get category by ID
  CategoryModel? getCategoryById(String id) {
    try {
      return _categories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get category by name
  CategoryModel? getCategoryByName(String name) {
    try {
      return _categories.firstWhere(
        (cat) => cat.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
}
