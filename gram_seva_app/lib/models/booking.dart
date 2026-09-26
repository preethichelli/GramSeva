class Booking {
  final String id;
  final String customerUid;
  final String workerId;
  final String societyId;
  final String serviceSlug;
  final String status; // requested | accepted | rejected | completed | cancelled
  final bool isEmergency;
  final int? rating;

  Booking({
    required this.id,
    required this.customerUid,
    required this.workerId,
    required this.societyId,
    required this.serviceSlug,
    required this.status,
    required this.isEmergency,
    this.rating,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'] as String,
      customerUid: json['customer_uid'] as String,
      workerId: json['worker_id'] as String,
      societyId: json['society_id'] as String,
      serviceSlug: json['service_slug'] as String,
      status: json['status'] as String,
      isEmergency: json['is_emergency'] ?? false,
      rating: json['rating'],
    );
  }
}
