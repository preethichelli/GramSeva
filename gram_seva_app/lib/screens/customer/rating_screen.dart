import 'package:flutter/material.dart';
import '../../models/booking.dart';
import '../../services/api_service.dart';
import '../../theme/app_theme.dart';

/// Post-job rating - stars + optional comment. This calls a real backend
/// endpoint (PATCH /bookings/{id}/rate), which also rolls the rating into
/// the worker's running average - it's not a local-only mock.
class RatingScreen extends StatefulWidget {
  final Booking booking;
  const RatingScreen({super.key, required this.booking});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  final _api = ApiService();
  final _commentController = TextEditingController();
  int _rating = 0;
  bool _submitting = false;
  String? _error;

  Future<void> _submit() async {
    if (_rating == 0) {
      setState(() => _error = 'Please select a star rating.');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await _api.rateBooking(widget.booking.id, rating: _rating, feedback: _commentController.text.trim());
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      setState(() => _error = 'Could not submit your rating. Try again.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rate this job')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.booking.serviceSlug.replaceAll('-', ' '),
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.ink),
            ),
            const SizedBox(height: 4),
            const Text('How was your experience?', style: TextStyle(fontSize: 12.5, color: AppColors.slate)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final filled = i < _rating;
                return IconButton(
                  iconSize: 36,
                  onPressed: () => setState(() => _rating = i + 1),
                  icon: Icon(filled ? Icons.star_rounded : Icons.star_border_rounded, color: AppColors.saffron),
                );
              }),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: const InputDecoration(hintText: 'Add a comment (optional)'),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: AppColors.error, fontSize: 12)),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Submit rating'),
            ),
          ],
        ),
      ),
    );
  }
}
