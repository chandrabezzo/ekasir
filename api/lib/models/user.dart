class User {
  final String id;
  final String username;
  final String password; // BCrypt hashed
  final String name;
  final String role;
  final List<String> outletIds;
  final String? outletName;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.name,
    required this.role,
    this.outletIds = const [],
    this.outletName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      outletIds: json['outletIds'] != null
          ? List<String>.from(json['outletIds'] as List)
          : [],
      outletName: json['outletName'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'role': role,
      'outletIds': outletIds,
      'outletName': outletName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // toJson without password for API responses
  Map<String, dynamic> toSafeJson() {
    final json = toJson();
    json.remove('password');
    return json;
  }

  User copyWith({
    String? id,
    String? username,
    String? password,
    String? name,
    String? role,
    List<String>? outletIds,
    String? outletName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      name: name ?? this.name,
      role: role ?? this.role,
      outletIds: outletIds ?? this.outletIds,
      outletName: outletName ?? this.outletName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
