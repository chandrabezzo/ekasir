import 'dart:convert';
import 'package:shelf/shelf.dart';

class ResponseHelper {
  static Response success({
    dynamic data,
    String message = 'Success',
    int statusCode = 200,
  }) {
    return Response.ok(
      json.encode({
        'success': true,
        'data': data,
        'message': message,
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }

  static Response error({
    required String message,
    String? code,
    int statusCode = 400,
  }) {
    return Response(
      statusCode,
      body: json.encode({
        'success': false,
        'error': message,
        if (code != null) 'code': code,
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }

  static Response unauthorized([String message = 'Unauthorized']) {
    return error(message: message, code: 'UNAUTHORIZED', statusCode: 401);
  }

  static Response forbidden([String message = 'Forbidden']) {
    return error(message: message, code: 'FORBIDDEN', statusCode: 403);
  }

  static Response notFound([String message = 'Resource not found']) {
    return error(message: message, code: 'NOT_FOUND', statusCode: 404);
  }

  static Response badRequest(String message) {
    return error(message: message, code: 'BAD_REQUEST', statusCode: 400);
  }

  static Response internalError([String message = 'Internal server error']) {
    return error(
        message: message, code: 'INTERNAL_ERROR', statusCode: 500);
  }
}
