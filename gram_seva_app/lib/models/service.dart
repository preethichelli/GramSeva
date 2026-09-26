class ServiceCategory {
  final String id;
  final String name;
  final String slug;
  final String icon;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.slug,
    required this.icon,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      id: json['_id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      icon: json['icon'] as String,
    );
  }
}
