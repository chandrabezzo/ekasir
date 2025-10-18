class UserModel {
  final String id;
  final String username;
  final String name;
  final String role;
  final List<String> outletIds; // List of outlet IDs user has access to
  final String? outletName; // Primary outlet name for display

  UserModel({
    required this.id,
    required this.username,
    required this.name,
    required this.role,
    this.outletIds = const [], // Empty list means access to all outlets
    this.outletName,
  });

  // Check if user has access to a specific outlet
  bool hasAccessToOutlet(String outletId) {
    // Empty list means access to all outlets (admin)
    if (outletIds.isEmpty) return true;
    return outletIds.contains(outletId);
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      outletIds: json['outletIds'] != null 
          ? List<String>.from(json['outletIds'] as List)
          : [],
      outletName: json['outletName'] as String?,
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
    };
  }
}
