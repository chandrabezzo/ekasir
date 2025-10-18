# Flutter App Integration Guide

## 1. Add HTTP Package to Flutter App

In your Flutter app's `pubspec.yaml`:
```yaml
dependencies:
  http: ^1.1.0
```

## 2. Create API Service Class

Create `lib/shared/services/api_service.dart`:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Change this to your backend URL
  static const String baseUrl = 'http://localhost:8080/api';
  
  // For web: use http://localhost:8080/api
  // For Android Emulator: use http://10.0.2.2:8080/api
  // For iOS Simulator: use http://localhost:8080/api
  // For Real Device: use http://YOUR_LOCAL_IP:8080/api
  
  final _prefs = Get.find<SharedPreferences>();
  
  String? get _token => _prefs.getString('auth_token');
  
  Map<String, String> get _headers {
    final headers = {'Content-Type': 'application/json'};
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  // Auth
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );
    
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: _headers,
    );
    
    return _handleResponse(response);
  }

  // Products
  Future<Map<String, dynamic>> getProducts({String? category}) async {
    var url = '$baseUrl/products';
    if (category != null) {
      url += '?category=$category';
    }
    
    final response = await http.get(
      Uri.parse(url),
      headers: _headers,
    );
    
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> createProduct(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: _headers,
      body: json.encode(data),
    );
    
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> updateProduct(
    String id,
    Map<String, dynamic> data,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/$id'),
      headers: _headers,
      body: json.encode(data),
    );
    
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> deleteProduct(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/products/$id'),
      headers: _headers,
    );
    
    return _handleResponse(response);
  }

  // Categories
  Future<Map<String, dynamic>> getCategories({bool? active}) async {
    var url = '$baseUrl/categories';
    if (active != null) {
      url += '?active=$active';
    }
    
    final response = await http.get(
      Uri.parse(url),
      headers: _headers,
    );
    
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> createCategory(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/categories'),
      headers: _headers,
      body: json.encode(data),
    );
    
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> updateCategory(
    String id,
    Map<String, dynamic> data,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/categories/$id'),
      headers: _headers,
      body: json.encode(data),
    );
    
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> deleteCategory(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/categories/$id'),
      headers: _headers,
    );
    
    return _handleResponse(response);
  }

  // Orders
  Future<Map<String, dynamic>> getOrders({String? status}) async {
    var url = '$baseUrl/orders';
    if (status != null) {
      url += '?status=$status';
    }
    
    final response = await http.get(
      Uri.parse(url),
      headers: _headers,
    );
    
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: _headers,
      body: json.encode(data),
    );
    
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> updateOrderStatus(
    String id,
    String status,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/orders/$id/status'),
      headers: _headers,
      body: json.encode({'status': status}),
    );
    
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getOrderStatistics() async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders/statistics'),
      headers: _headers,
    );
    
    return _handleResponse(response);
  }

  // Response handler
  Map<String, dynamic> _handleResponse(http.Response response) {
    final data = json.decode(response.body) as Map<String, dynamic>;
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw ApiException(
        message: data['error'] ?? 'Unknown error',
        statusCode: response.statusCode,
        code: data['code'],
      );
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  final String? code;

  ApiException({
    required this.message,
    required this.statusCode,
    this.code,
  });

  @override
  String toString() => message;
}
```

## 3. Initialize in Main App

In `lib/app/app_binding.dart`:
```dart
import '../shared/services/api_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // ... existing dependencies
    Get.put(ApiService(), permanent: true);
  }
}
```

## 4. Update Auth Controller

In `lib/features/auth/auth_controller.dart`:

```dart
import '../../shared/services/api_service.dart';

class AuthController extends GetxController {
  final ApiService _apiService = Get.find();
  final _prefs = Get.find<SharedPreferences>();
  
  Future<bool> login(String username, String password) async {
    try {
      final response = await _apiService.login(username, password);
      
      if (response['success'] == true) {
        final token = response['data']['token'] as String;
        final userData = response['data']['user'] as Map<String, dynamic>;
        
        // Save token
        await _prefs.setString('auth_token', token);
        
        // Save user data
        final user = UserModel.fromJson(userData);
        _currentUser.value = user;
        
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }
  
  Future<void> logout() async {
    await _prefs.remove('auth_token');
    _currentUser.value = null;
  }
}
```

## 5. Update Menu Controller

In `lib/features/menu/menu_controller.dart`:

```dart
import '../../shared/services/api_service.dart';

class MenuManagementController extends GetxController {
  final ApiService _apiService = Get.find();
  
  Future<void> _loadMenus() async {
    _isLoading.value = true;
    
    try {
      final response = await _apiService.getProducts();
      
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        _menus.value = data.map((json) => ProductModel.fromJson(json)).toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load menus: $e');
    } finally {
      _isLoading.value = false;
    }
  }
  
  Future<bool> addMenu(ProductModel menu) async {
    _isLoading.value = true;
    
    try {
      final response = await _apiService.createProduct(menu.toJson());
      
      if (response['success'] == true) {
        final newMenu = ProductModel.fromJson(response['data']);
        _menus.add(newMenu);
        
        Get.snackbar('Success', 'Menu added successfully');
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to add menu: $e');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }
  
  // Similar updates for updateMenu, deleteMenu, etc.
}
```

## 6. Update Category Controller

Similar pattern as Menu Controller - replace mock data with API calls.

## 7. Platform-Specific Base URLs

Create `lib/shared/config/api_config.dart`:

```dart
import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      // Web - use localhost or your domain
      return 'http://localhost:8080/api';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      // Android Emulator
      return 'http://10.0.2.2:8080/api';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      // iOS Simulator
      return 'http://localhost:8080/api';
    } else {
      // Real device - replace with your computer's IP
      return 'http://192.168.1.100:8080/api';
    }
  }
}
```

Then update `ApiService`:
```dart
import '../config/api_config.dart';

class ApiService {
  static String get baseUrl => ApiConfig.baseUrl;
  // ... rest of the code
}
```

## 8. CORS Configuration (Already Done)

The backend already has CORS enabled for all origins. For production, update `lib/routes.dart`:

```dart
final _corsHeaders = {
  'Access-Control-Allow-Origin': 'https://your-production-domain.com',
  // ... other headers
};
```

## 9. Error Handling

Add global error handling in controllers:

```dart
try {
  final response = await _apiService.someMethod();
  // Handle success
} on ApiException catch (e) {
  if (e.statusCode == 401) {
    // Unauthorized - logout user
    Get.find<AuthController>().logout();
    Get.offAllNamed(LoginPage.routeName);
  } else {
    Get.snackbar('Error', e.message);
  }
} catch (e) {
  Get.snackbar('Error', 'An unexpected error occurred');
}
```

## 10. Testing

1. **Start Backend Server**:
```bash
cd api
dart run bin/server.dart
```

2. **Run Flutter App**:
```bash
cd ..
flutter run -d chrome  # For web
# or
flutter run  # For mobile
```

3. **Test Login**:
   - Username: `admin`
   - Password: `admin123`

## Quick Tips

- **Network Error on Mobile**: Make sure your device and computer are on the same network
- **CORS Error on Web**: Already handled by the backend
- **401 Errors**: Check if token is being sent correctly in headers
- **Connection Refused**: Verify backend is running and firewall allows connections

## Production Deployment

1. Update `ApiConfig.baseUrl` to your production API URL
2. Build Flutter app: `flutter build web` or `flutter build apk`
3. Deploy backend to cloud service (Heroku, DigitalOcean, AWS, etc.)
4. Update CORS settings to allow only your frontend domain
