class CategoryModel {
  final String id;
  final String name;
  final String description;
  final String? iconName; // Icon name as string for persistence
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    this.iconName,
    this.isActive = true,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconName: json['iconName'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconName': iconName,
      'isActive': isActive,
    };
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    String? iconName,
    bool? isActive,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      isActive: isActive ?? this.isActive,
    );
  }
}
