import 'package:uuid/uuid.dart';
import '../models/product.dart';

class ProductRepository {
  final Map<String, Product> _products = {};
  final _uuid = const Uuid();

  ProductRepository() {
    _seedProducts();
  }

  void _seedProducts() {
    final now = DateTime.now();
    final products = [
      Product(
        id: _uuid.v4(),
        name: 'Nasi Goreng Spesial',
        description: 'Nasi goreng dengan telur, ayam, dan sayuran',
        price: 25000,
        category: 'Food',
        imageUrl: 'https://via.placeholder.com/150',
        isAvailable: true,
        createdAt: now,
        updatedAt: now,
      ),
      Product(
        id: _uuid.v4(),
        name: 'Mie Goreng',
        description: 'Mie goreng dengan topping ayam dan sayuran',
        price: 20000,
        category: 'Food',
        imageUrl: 'https://via.placeholder.com/150',
        isAvailable: true,
        createdAt: now,
        updatedAt: now,
      ),
      Product(
        id: _uuid.v4(),
        name: 'Es Teh Manis',
        description: 'Teh manis dingin segar',
        price: 5000,
        category: 'Beverage',
        imageUrl: 'https://via.placeholder.com/150',
        isAvailable: true,
        createdAt: now,
        updatedAt: now,
      ),
      Product(
        id: _uuid.v4(),
        name: 'Kopi Hitam',
        description: 'Kopi hitam original tanpa gula',
        price: 10000,
        category: 'Beverage',
        imageUrl: 'https://via.placeholder.com/150',
        isAvailable: true,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    for (final product in products) {
      _products[product.id] = product;
    }
  }

  Future<Product> create(Product product) async {
    final newProduct = product.copyWith(
      id: _uuid.v4(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _products[newProduct.id] = newProduct;
    return newProduct;
  }

  Future<List<Product>> getAll({String? category, bool? available}) async {
    var products = _products.values.toList();

    if (category != null && category != 'all') {
      products = products.where((p) => p.category == category).toList();
    }

    if (available != null) {
      products = products.where((p) => p.isAvailable == available).toList();
    }

    return products;
  }

  Future<Product?> getById(String id) async {
    return _products[id];
  }

  Future<Product?> update(String id, Map<String, dynamic> data) async {
    final product = _products[id];
    if (product == null) return null;

    final updatedProduct = product.copyWith(
      name: data['name'] ?? product.name,
      description: data['description'] ?? product.description,
      price: data['price'] ?? product.price,
      imageUrl: data['imageUrl'] ?? product.imageUrl,
      category: data['category'] ?? product.category,
      isAvailable: data['isAvailable'] ?? product.isAvailable,
      updatedAt: DateTime.now(),
    );

    _products[id] = updatedProduct;
    return updatedProduct;
  }

  Future<bool> delete(String id) async {
    return _products.remove(id) != null;
  }

  Future<List<String>> getCategories() async {
    return _products.values.map((p) => p.category).toSet().toList();
  }
}
