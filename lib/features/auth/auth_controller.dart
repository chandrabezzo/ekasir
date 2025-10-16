import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../shared/models/user_model.dart';

class AuthController extends GetxController {
  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  final RxBool _isLoading = false.obs;
  final _sharedPreferences = Get.find<SharedPreferences>();

  UserModel? get currentUser => _currentUser.value;
  bool get isLoading => _isLoading.value;
  bool get isLoggedIn => _currentUser.value != null;

  // Mock users - Replace with API in production
  final Map<String, Map<String, String>> _mockUsers = {
    'admin': {
      'password': _hashPassword('admin123'), // admin123
      'name': 'Admin Cafe',
      'role': 'admin',
    },
    'kasir1': {
      'password': _hashPassword('kasir123'), // kasir123
      'name': 'Kasir 1',
      'role': 'cashier',
    },
    'kasir2': {
      'password': _hashPassword('kasir456'), // kasir456
      'name': 'Kasir 2',
      'role': 'cashier',
    },
  };

  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
  }

  // Hash password using SHA256
  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Load user from storage
  Future<void> _loadUserFromStorage() async {
    final userJson = _sharedPreferences.getString('current_user');
    if (userJson != null) {
      try {
        final userData = json.decode(userJson) as Map<String, dynamic>;
        _currentUser.value = UserModel.fromJson(userData);
      } catch (e) {
        // If parsing fails, clear storage
        await _sharedPreferences.remove('current_user');
      }
    }
  }

  // Login method
  Future<bool> login(String username, String password) async {
    _isLoading.value = true;

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Check credentials
      final user = _mockUsers[username.toLowerCase()];
      if (user == null) {
        Get.snackbar(
          'Login Gagal',
          'Username tidak ditemukan',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        _isLoading.value = false;
        return false;
      }

      final hashedPassword = _hashPassword(password);
      if (user['password'] != hashedPassword) {
        Get.snackbar(
          'Login Gagal',
          'Password salah',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        _isLoading.value = false;
        return false;
      }

      // Create user model
      final userModel = UserModel(
        id: username,
        username: username,
        name: user['name']!,
        role: user['role']!,
      );

      // Save to storage
      await _sharedPreferences.setString(
        'current_user',
        json.encode(userModel.toJson()),
      );

      _currentUser.value = userModel;

      Get.snackbar(
        'Login Berhasil',
        'Selamat datang, ${userModel.name}',
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
        'Terjadi kesalahan saat login',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      _isLoading.value = false;
      return false;
    }
  }

  // Logout method
  Future<void> logout() async {
    await _sharedPreferences.remove('current_user');
    _currentUser.value = null;
    
    Get.snackbar(
      'Logout Berhasil',
      'Anda telah keluar dari sistem',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  // Check if user has permission
  bool hasPermission(String permission) {
    if (_currentUser.value == null) return false;
    if (_currentUser.value!.role == 'admin') return true;
    
    // Add more permission checks as needed
    return false;
  }
}
