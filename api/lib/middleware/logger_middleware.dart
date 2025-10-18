import 'package:shelf/shelf.dart';

Middleware loggerMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      final startTime = DateTime.now();
      
      print('[${startTime.toIso8601String()}] ${request.method} ${request.url}');
      
      final response = await innerHandler(request);
      
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;
      
      print('[${endTime.toIso8601String()}] ${response.statusCode} ${request.method} ${request.url} - ${duration}ms');
      
      return response;
    };
  };
}
