import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/worker.dart';
import '../models/service.dart';
import '../models/booking.dart';
import '../models/society.dart';

class ApiService {
  // Point this at your running FastAPI instance.
  // - Chrome / Windows desktop (what you're using): http://localhost:8000
  // - Android emulator instead: http://10.0.2.2:8000
  // - Physical device on same wifi: http://<your-laptop-lan-ip>:8000
  // - Deployed backend: your Cloud Run / Render URL
  static const String baseUrl = 'http://10.0.2.2:8000';

  final String? idToken; // Firebase ID token, once auth is wired up

  ApiService({this.idToken});

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (idToken != null) 'Authorization': 'Bearer $idToken',
      };

  // ---- Services ----

  Future<List<ServiceCategory>> getServices() async {
    final res =
        await http.get(Uri.parse('$baseUrl/services/'), headers: _headers);
    _checkOk(res);
    final List data = jsonDecode(res.body);
    return data.map((e) => ServiceCategory.fromJson(e)).toList();
  }

  // ---- Societies ----

  Future<List<Society>> getSocieties({bool verifiedOnly = false}) async {
    final uri = Uri.parse('$baseUrl/societies/').replace(
      queryParameters: {'verified_only': verifiedOnly.toString()},
    );
    final res = await http.get(uri, headers: _headers);
    _checkOk(res);
    final List data = jsonDecode(res.body);
    return data.map((e) => Society.fromJson(e)).toList();
  }

  // ---- Workers ----

  Future<List<Worker>> getWorkers(
      {String? skill, bool verifiedOnly = true}) async {
    final query = {
      if (skill != null) 'skill': skill,
      'verified_only': verifiedOnly.toString(),
    };
    final uri = Uri.parse('$baseUrl/workers/').replace(queryParameters: query);
    final res = await http.get(uri, headers: _headers);
    _checkOk(res);
    final List data = jsonDecode(res.body);
    return data.map((e) => Worker.fromJson(e)).toList();
  }

  Future<Worker> registerWorker({
    required String name,
    required String phone,
    required String firebaseUid,
    required String societyId,
    required List<String> skills,
    int experienceYears = 0,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/workers/'),
      headers: _headers,
      body: jsonEncode({
        'name': name,
        'phone': phone,
        'firebase_uid': firebaseUid,
        'society_id': societyId,
        'skills': skills,
        'experience_years': experienceYears,
      }),
    );
    _checkOk(res);
    return Worker.fromJson(jsonDecode(res.body));
  }

  // ---- Bookings ----

  Future<Booking> createBooking({
    required String customerUid,
    required String workerId,
    required String serviceSlug,
    double? customerLat,
    double? customerLng,
    bool isEmergency = false,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/bookings/'),
      headers: _headers,
      body: jsonEncode({
        'customer_uid': customerUid,
        'worker_id': workerId,
        'service_slug': serviceSlug,
        'customer_lat': customerLat,
        'customer_lng': customerLng,
        'is_emergency': isEmergency,
      }),
    );
    _checkOk(res);
    return Booking.fromJson(jsonDecode(res.body));
  }

  Future<List<Booking>> getWorkerBookings(String workerId) async {
    final res = await http.get(Uri.parse('$baseUrl/bookings/worker/$workerId'),
        headers: _headers);
    _checkOk(res);
    final List data = jsonDecode(res.body);
    return data.map((e) => Booking.fromJson(e)).toList();
  }

  Future<List<Booking>> getCustomerBookings(String customerUid) async {
    final res = await http.get(
        Uri.parse('$baseUrl/bookings/customer/$customerUid'),
        headers: _headers);
    _checkOk(res);
    final List data = jsonDecode(res.body);
    return data.map((e) => Booking.fromJson(e)).toList();
  }

  Future<Booking> updateBookingStatus(String bookingId, String status) async {
    final res = await http.patch(
      Uri.parse('$baseUrl/bookings/$bookingId/status'),
      headers: _headers,
      body: jsonEncode({'status': status}),
    );
    _checkOk(res);
    return Booking.fromJson(jsonDecode(res.body));
  }

  // The rating updates the booking record and rolls into the worker's
  // running rating_avg on the backend - this hits a real endpoint, not a
  // mock. It takes rating/feedback as query params (matching the
  // FastAPI route signature), not a JSON body.
  Future<void> rateBooking(String bookingId,
      {required int rating, String feedback = ''}) async {
    final uri = Uri.parse('$baseUrl/bookings/$bookingId/rate').replace(
      queryParameters: {'rating': rating.toString(), 'feedback': feedback},
    );
    final res = await http.patch(uri, headers: _headers);
    _checkOk(res);
  }

  void _checkOk(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('API error ${res.statusCode}: ${res.body}');
    }
  }
}
