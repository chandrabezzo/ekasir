import 'package:uuid/uuid.dart';
import '../models/category.dart';

class CategoryRepository {
  final Map<String, Category> _categories = {};
  final _uuid = const Uuid();

  CategoryRepository() {
    _seedCategories();
  }

  void _seedCategories() {
    final now = DateTime.now();
    final categories = [
      Category(
        id: _uuid.v4(),
        name: 'Food',
        description: 'Makanan utama dan lauk pauk',
        iconName: 'restaurant',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      Category(
        id: _uuid.v4(),
        name: 'Beverage',
        description: 'Minuman panas dan dingin',
        iconName: 'local_cafe',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      Category(
        id: _uuid.v4(),
        name: 'Snack',
        description: 'Camilan dan makanan ringan',
        iconName: 'fastfood',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      Category(
        id: _uuid.v4(),
        name: 'Dessert',
        description: 'Makanan penutup dan pencuci mulut',
        iconName: 'cake',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    for (final category in categories) {
      _categories[category.id] = category;
    }
  }

  Future<Category> create(Category category) async {
    final newCategory = category.copyWith(
      id: _uuid.v4(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _categories[newCategory.id] = newCategory;
    return newCategory;
  }

  Future<List<Category>> getAll({bool? active}) async {
    var categories = _categories.values.toList();

    if (active != null) {
      categories = categories.where((c) => c.isActive == active).toList();
    }

    return categories;
  }

  Future<Category?> getById(String id) async {
    return _categories[id];
  }

  Future<Category?> getByName(String name) async {
    try {
      return _categories.values.firstWhere(
        (c) => c.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  Future<Category?> update(String id, Map<String, dynamic> data) async {
    final category = _categories[id];
    if (category == null) return null;

    final updatedCategory = category.copyWith(
      name: data['name'] ?? category.name,
      description: data['description'] ?? category.description,
      iconName: data['iconName'] ?? category.iconName,
      isActive: data['isActive'] ?? category.isActive,
      updatedAt: DateTime.now(),
    );

    _categories[id] = updatedCategory;
    return updatedCategory;
  }

  Future<bool> delete(String id) async {
    return _categories.remove(id) != null;
  }

  Future<bool> nameExists(String name, {String? excludeId}) async {
    return _categories.values.any(
      (c) =>
          c.name.toLowerCase() == name.toLowerCase() &&
          (excludeId == null || c.id != excludeId),
    );
  }
}
