import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../repositories/user_repository.dart';
import '../utils/response_helper.dart';

class UserHandler {
  final UserRepository userRepository;

  UserHandler(this.userRepository);

  Router get router {
    final router = Router();

    router.get('/', _getAll);
    router.get('/<id>', _getById);
    router.put('/<id>', _update);
    router.delete('/<id>', _delete);

    return router;
  }

  Future<Response> _getAll(Request request) async {
    try {
      final users = await userRepository.getAll();

      return ResponseHelper.success(
        data: users.map((u) => u.toSafeJson()).toList(),
      );
    } catch (e) {
      return ResponseHelper.internalError(e.toString());
    }
  }

  Future<Response> _getById(Request request, String id) async {
    try {
      final user = await userRepository.getById(id);

      if (user == null) {
        return ResponseHelper.notFound('User not found');
      }

      return ResponseHelper.success(data: user.toSafeJson());
    } catch (e) {
      return ResponseHelper.internalError(e.toString());
    }
  }

  Future<Response> _update(Request request, String id) async {
    try {
      final body = await request.readAsString();
      final data = json.decode(body) as Map<String, dynamic>;

      // Check if updating username and it already exists
      if (data['username'] != null) {
        final existingUser = await userRepository.getById(id);
        if (existingUser == null) {
          return ResponseHelper.notFound('User not found');
        }

        if (existingUser.username != data['username']) {
          if (await userRepository.usernameExists(data['username'] as String)) {
            return ResponseHelper.badRequest('Username already exists');
          }
        }
      }

      final user = await userRepository.update(id, data);

      if (user == null) {
        return ResponseHelper.notFound('User not found');
      }

      return ResponseHelper.success(
        data: user.toSafeJson(),
        message: 'User updated successfully',
      );
    } catch (e) {
      return ResponseHelper.internalError(e.toString());
    }
  }

  Future<Response> _delete(Request request, String id) async {
    try {
      final deleted = await userRepository.delete(id);

      if (!deleted) {
        return ResponseHelper.notFound('User not found');
      }

      return ResponseHelper.success(message: 'User deleted successfully');
    } catch (e) {
      return ResponseHelper.internalError(e.toString());
    }
  }
}
