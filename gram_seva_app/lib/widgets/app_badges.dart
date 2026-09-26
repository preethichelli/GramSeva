import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// The platform's single trust signal - a green shield/check plus the
/// word "Verified" wherever a worker or cooperative society appears.
/// Per the design system: never a star (stars are reserved for ratings),
/// never substituted with error-red for an unverified state.
class VerifiedBadge extends StatelessWidget {
  final double iconSize;
  final bool showLabel;
  const VerifiedBadge({super.key, this.iconSize = 15, this.showLabel = true});

  @override
  Widget build(BuildContext context) {
    if (!showLabel) {
      return Icon(Icons.verified_rounded, size: iconSize, color: AppColors.leafGreen);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.verified_rounded, size: iconSize, color: AppColors.leafGreen),
        const SizedBox(width: 3),
        Text('Verified',
            style: TextStyle(fontSize: iconSize * 0.73, fontWeight: FontWeight.w700, color: AppColors.green700)),
      ],
    );
  }
}

/// Coral + saffron "EMERGENCY" flag, used identically in the household
/// booking flow and on worker request cards so the treatment is instantly
/// recognizable in both places.
class EmergencyBadge extends StatelessWidget {
  final String label;
  const EmergencyBadge({super.key, this.label = 'EMERGENCY'});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.urgentCoral,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt_rounded, size: 13, color: Colors.white),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.3)),
        ],
      ),
    );
  }
}

/// Small rounded status chip for booking states (requested / accepted /
/// rejected / completed / cancelled) - one consistent pill shape, color
/// varies by status.
class BookingStatusChip extends StatelessWidget {
  final String status;
  const BookingStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = _colorsFor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: colors[0], borderRadius: BorderRadius.circular(AppRadius.pill)),
      child: Text(
        _label(status),
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: colors[1]),
      ),
    );
  }

  String _label(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  List<Color> _colorsFor(String s) {
    switch (s) {
      case 'accepted':
        return [AppColors.teal100, AppColors.deepTeal];
      case 'completed':
        return [const Color(0xFFE3F2E8), AppColors.green700];
      case 'rejected':
        return [const Color(0xFFFBE4E1), AppColors.error];
      case 'cancelled':
        return [AppColors.mist, AppColors.slate];
      case 'requested':
      default:
        return [AppColors.sand, AppColors.saffron700];
    }
  }
}
