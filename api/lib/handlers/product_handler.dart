import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../repositories/product_repository.dart';
import '../utils/response_helper.dart';
import '../models/product.dart';

class ProductHandler {
  final ProductRepository productRepository;

  ProductHandler(this.productRepository);

  Router get router {
    final router = Router();

    router.get('/', _getAll);
    router.get('/<id>', _getById);
    router.post('/', _create);
    router.put('/<id>', _update);
    router.delete('/<id>', _delete);

    return router;
  }

  Future<Response> _getAll(Request request) async {
    try {
      final category = request.url.queryParameters['category'];
      final availableStr = request.url.queryParameters['available'];
      final available =
          availableStr != null ? availableStr == 'true' : null;

      final products = await productRepository.getAll(
        category: category,
        available: available,
      );

      return ResponseHelper.success(data: products.map((p) => p.toJson()).toList());
    } catch (e) {
      return ResponseHelper.internalError(e.toString());
    }
  }

  Future<Response> _getById(Request request, String id) async {
    try {
      final product = await productRepository.getById(id);

      if (product == null) {
        return ResponseHelper.notFound('Product not found');
      }

      return ResponseHelper.success(data: product.toJson());
    } catch (e) {
      return ResponseHelper.internalError(e.toString());
    }
  }

  Future<Response> _create(Request request) async {
    try {
      final body = await request.readAsString();
      final data = json.decode(body) as Map<String, dynamic>;

      final name = data['name'] as String?;
      final description = data['description'] as String?;
      final price = data['price'] as num?;
      final category = data['category'] as String?;

      if (name == null ||
          description == null ||
          price == null ||
          category == null) {
        return ResponseHelper.badRequest(
            'Name, description, price, and category are required');
      }

      final newProduct = Product(
        id: '',
        name: name,
        description: description,
        price: price.toDouble(),
        imageUrl: data['imageUrl'] as String?,
        category: category,
        isAvailable: data['isAvailable'] ?? true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final product = await productRepository.create(newProduct);

      return ResponseHelper.success(
        data: product.toJson(),
        message: 'Product created successfully',
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

      final product = await productRepository.update(id, data);

      if (product == null) {
        return ResponseHelper.notFound('Product not found');
      }

      return ResponseHelper.success(
        data: product.toJson(),
        message: 'Product updated successfully',
      );
    } catch (e) {
      return ResponseHelper.internalError(e.toString());
    }
  }

  Future<Response> _delete(Request request, String id) async {
    try {
      final deleted = await productRepository.delete(id);

      if (!deleted) {
        return ResponseHelper.notFound('Product not found');
      }

      return ResponseHelper.success(message: 'Product deleted successfully');
    } catch (e) {
      return ResponseHelper.internalError(e.toString());
    }
  }
}
