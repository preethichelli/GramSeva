import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../localization/app_strings.dart';
import '../../models/service.dart';
import '../../models/worker.dart';
import '../../services/api_service.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../theme/service_style.dart';
import '../../widgets/worker_card.dart';
import '../worker/worker_registration_screen.dart';
import 'booking_confirmation_screen.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final _api = ApiService();
  List<ServiceCategory> _services = [];
  List<Worker> _workers = [];
  String? _selectedSlug;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final services = await _api.getServices();
      final workers = await _api.getWorkers();
      setState(() {
        _services = services;
        _workers = workers;
      });
    } catch (_) {
      // Prototype-stage: swallow errors here, show empty state below.
      // Wire up a real snackbar/error banner before your demo.
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _filterByService(String slug) async {
    setState(() => _selectedSlug = _selectedSlug == slug ? null : slug);
    final workers = await _api.getWorkers(skill: _selectedSlug);
    setState(() => _workers = workers);
  }

  // The only door into worker mode - de-emphasized, buried below the
  // main household content rather than a peer toggle. A worker who has
  // already registered this session skips straight back into worker
  // mode; a first-time tap starts registration.
  void _goToWorkerSide() {
    final appState = context.read<AppState>();
    if (appState.workerRegistered) {
      appState.setRole(UserRole.worker);
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => const WorkerRegistrationScreen()));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    final lang = context.watch<AppState>().languageCode;

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const _HouseholdHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: AppStrings.t('searchService', lang),
                    prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.slate),
                  ),
                  readOnly: true,
                  onTap: () {}, // hook up a search screen when you have time
                ),
                const SizedBox(height: 22),
                Text(AppStrings.t('services', lang),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.ink)),
                const SizedBox(height: 14),
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.78,
                  // Show every service category with its own icon, per the
                  // PS's full worker list - no "More" tile hiding categories.
                  children: _services
                      .map((s) => _ServiceTile(
                            iconKey: s.icon,
                            label: s.name,
                            selected: _selectedSlug == s.slug,
                            onTap: () => _filterByService(s.slug),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Icon(Icons.verified_rounded, size: 18, color: AppColors.leafGreen),
                    const SizedBox(width: 6),
                    Text(AppStrings.t('verifiedWorkersNearby', lang),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink)),
                  ],
                ),
                const SizedBox(height: 10),
                if (_workers.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(AppStrings.t('noVerifiedWorkers', lang), style: const TextStyle(color: AppColors.slate)),
                  )
                else
                  ..._workers.map((w) => WorkerCard(
                        worker: w,
                        societyName: w.societyId, // swap for a real society lookup once societies caching is in
                        onBook: () => _goToBookingConfirmation(w),
                      )),
                const SizedBox(height: 4),
                _WorkerRegistrationBanner(languageCode: lang, onTap: _goToWorkerSide),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _goToBookingConfirmation(Worker worker) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingConfirmationScreen(
          worker: worker,
          societyName: worker.societyId, // swap for a real society lookup once cached
          serviceSlug: _selectedSlug ?? worker.skills.first,
        ),
      ),
    );
  }
}

class _HouseholdHeader extends StatelessWidget {
  const _HouseholdHeader();

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<AppState>().languageCode;
    return Container(
      color: AppColors.warmIvory,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: AppColors.teal100, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.cottage_rounded, color: AppColors.deepTeal, size: 21),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.t('appTitle', lang),
                    style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.deepTeal)),
                const Text('Trusted services. Stronger communities.',
                    style: TextStyle(fontSize: 10.5, color: AppColors.slate)),
              ],
            ),
          ),
          // Mock location context - GramSeva doesn't call the geolocator
          // package yet, so this deliberately shows a generic label
          // rather than a fabricated place name or distance.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: AppColors.teal100, borderRadius: BorderRadius.circular(AppRadius.pill)),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on_rounded, size: 13, color: AppColors.deepTeal),
                SizedBox(width: 3),
                Text('Your area', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.deepTeal)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final String iconKey;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ServiceTile({required this.iconKey, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tileColor = ServiceStyle.tileColorFor(iconKey);
    final iconColor = ServiceStyle.tileIconColorFor(iconKey);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: selected ? AppColors.deepTeal : tileColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(ServiceStyle.iconFor(iconKey), size: 24, color: selected ? Colors.white : iconColor),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              color: selected ? AppColors.deepTeal : AppColors.ink,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _WorkerRegistrationBanner extends StatelessWidget {
  final String languageCode;
  final VoidCallback onTap;
  const _WorkerRegistrationBanner({required this.languageCode, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.sand, borderRadius: BorderRadius.circular(AppRadius.card)),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(color: AppColors.saffron.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.engineering_rounded, color: AppColors.saffron700, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.t('areYouSkilledWorker', languageCode),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink)),
                  const SizedBox(height: 2),
                  Text(AppStrings.t('register', languageCode),
                      style: const TextStyle(fontSize: 12, color: AppColors.slate)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.slate),
          ],
        ),
      ),
    );
  }
}
