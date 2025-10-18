import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../repositories/category_repository.dart';
import '../utils/response_helper.dart';
import '../models/category.dart';

class CategoryHandler {
  final CategoryRepository categoryRepository;

  CategoryHandler(this.categoryRepository);

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
      final activeStr = request.url.queryParameters['active'];
      final active = activeStr != null ? activeStr == 'true' : null;

      final categories = await categoryRepository.getAll(active: active);

      return ResponseHelper.success(
          data: categories.map((c) => c.toJson()).toList());
    } catch (e) {
      return ResponseHelper.internalError(e.toString());
    }
  }

  Future<Response> _getById(Request request, String id) async {
    try {
      final category = await categoryRepository.getById(id);

      if (category == null) {
        return ResponseHelper.notFound('Category not found');
      }

      return ResponseHelper.success(data: category.toJson());
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

      if (name == null || description == null) {
        return ResponseHelper.badRequest('Name and description are required');
      }

      // Check if category name already exists
      if (await categoryRepository.nameExists(name)) {
        return ResponseHelper.badRequest('Category name already exists');
      }

      final newCategory = Category(
        id: '',
        name: name,
        description: description,
        iconName: data['iconName'] as String?,
        isActive: data['isActive'] ?? true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final category = await categoryRepository.create(newCategory);

      return ResponseHelper.success(
        data: category.toJson(),
        message: 'Category created successfully',
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

      // Check if new name conflicts with existing categories
      if (data['name'] != null) {
        if (await categoryRepository.nameExists(
            data['name'] as String, excludeId: id)) {
          return ResponseHelper.badRequest('Category name already exists');
        }
      }

      final category = await categoryRepository.update(id, data);

      if (category == null) {
        return ResponseHelper.notFound('Category not found');
      }

      return ResponseHelper.success(
        data: category.toJson(),
        message: 'Category updated successfully',
      );
    } catch (e) {
      return ResponseHelper.internalError(e.toString());
    }
  }

  Future<Response> _delete(Request request, String id) async {
    try {
      final deleted = await categoryRepository.delete(id);

      if (!deleted) {
        return ResponseHelper.notFound('Category not found');
      }

      return ResponseHelper.success(message: 'Category deleted successfully');
    } catch (e) {
      return ResponseHelper.internalError(e.toString());
    }
  }
}
