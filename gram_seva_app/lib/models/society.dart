class Society {
  final String id;
  final String name;
  final String? federationName;
  final String district;
  final String state;
  final bool verified;

  Society({
    required this.id,
    required this.name,
    this.federationName,
    required this.district,
    required this.state,
    required this.verified,
  });

  factory Society.fromJson(Map<String, dynamic> json) {
    return Society(
      id: json['_id'] as String,
      name: json['name'] as String,
      federationName: json['federation_name'],
      district: json['district'] as String,
      state: json['state'] as String,
      verified: json['verified'] ?? false,
    );
  }
}
