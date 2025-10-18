import 'package:uuid/uuid.dart';
import 'package:bcrypt/bcrypt.dart';
import '../models/user.dart';

class UserRepository {
  // In-memory storage (replace with actual database)
  final Map<String, User> _users = {};
  final _uuid = const Uuid();

  UserRepository() {
    // Seed with default users
    _seedUsers();
  }

  void _seedUsers() {
    final now = DateTime.now();
    
    // Admin user
    final admin = User(
      id: _uuid.v4(),
      username: 'admin',
      password: BCrypt.hashpw('admin123', BCrypt.gensalt()),
      name: 'Administrator',
      role: 'admin',
      outletIds: [],
      outletName: 'Main Outlet',
      createdAt: now,
      updatedAt: now,
    );
    _users[admin.id] = admin;

    // Cashier user
    final cashier = User(
      id: _uuid.v4(),
      username: 'cashier',
      password: BCrypt.hashpw('cashier123', BCrypt.gensalt()),
      name: 'Cashier User',
      role: 'cashier',
      outletIds: ['outlet-1'],
      outletName: 'Main Outlet',
      createdAt: now,
      updatedAt: now,
    );
    _users[cashier.id] = cashier;
  }

  // Create user
  Future<User> create(User user) async {
    final hashedPassword = BCrypt.hashpw(user.password, BCrypt.gensalt());
    final newUser = user.copyWith(
      id: _uuid.v4(),
      password: hashedPassword,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _users[newUser.id] = newUser;
    return newUser;
  }

  // Get all users
  Future<List<User>> getAll() async {
    return _users.values.toList();
  }

  // Get user by ID
  Future<User?> getById(String id) async {
    return _users[id];
  }

  // Get user by username
  Future<User?> getByUsername(String username) async {
    try {
      return _users.values.firstWhere(
        (user) => user.username == username,
      );
    } catch (e) {
      return null;
    }
  }

  // Update user
  Future<User?> update(String id, Map<String, dynamic> data) async {
    final user = _users[id];
    if (user == null) return null;

    final updatedUser = user.copyWith(
      username: data['username'] ?? user.username,
      name: data['name'] ?? user.name,
      role: data['role'] ?? user.role,
      outletIds: data['outletIds'] ?? user.outletIds,
      outletName: data['outletName'] ?? user.outletName,
      updatedAt: DateTime.now(),
    );

    // Update password if provided
    if (data['password'] != null) {
      final hashedPassword =
          BCrypt.hashpw(data['password'] as String, BCrypt.gensalt());
      _users[id] = updatedUser.copyWith(password: hashedPassword);
    } else {
      _users[id] = updatedUser;
    }

    return _users[id];
  }

  // Delete user
  Future<bool> delete(String id) async {
    return _users.remove(id) != null;
  }

  // Verify password
  bool verifyPassword(User user, String password) {
    return BCrypt.checkpw(password, user.password);
  }

  // Check if username exists
  Future<bool> usernameExists(String username) async {
    return _users.values.any((user) => user.username == username);
  }
}
