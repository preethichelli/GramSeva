class Worker {
  final String id;
  final String name;
  final String phone;
  final String societyId;
  final String? societyName; // filled in by UI after a societies lookup, optional
  final List<String> skills;
  final int experienceYears;
  final bool verified;
  final bool available;
  final double ratingAvg;
  final int ratingCount;

  Worker({
    required this.id,
    required this.name,
    required this.phone,
    required this.societyId,
    this.societyName,
    required this.skills,
    required this.experienceYears,
    required this.verified,
    required this.available,
    required this.ratingAvg,
    required this.ratingCount,
  });

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      id: json['_id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      societyId: json['society_id'] as String,
      skills: List<String>.from(json['skills'] ?? []),
      experienceYears: json['experience_years'] ?? 0,
      verified: json['verified'] ?? false,
      available: json['available'] ?? true,
      ratingAvg: (json['rating_avg'] ?? 0).toDouble(),
      ratingCount: json['rating_count'] ?? 0,
    );
  }
}
