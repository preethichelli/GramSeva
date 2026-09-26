import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Maps each service category's backend icon key to a Material icon and
/// a soft tinted tile color, matching the service grid from the Manus
/// UI/UX handoff. Icons are chosen from Flutter's standard Icons set
/// only (no icon font packages added), to keep the dependency footprint
/// unchanged.
class ServiceStyle {
  static const Map<String, IconData> icons = {
    'ti-bulb': Icons.bolt_rounded,
    'ti-droplet': Icons.water_drop_rounded,
    'ti-hammer': Icons.hardware_rounded,
    'ti-brush': Icons.format_paint_rounded,
    'ti-home-2': Icons.home_rounded,
    'ti-heart-handshake': Icons.favorite_rounded,
    'ti-steering-wheel': Icons.directions_car_rounded,
    'ti-plant-2': Icons.eco_rounded,
    'ti-spray': Icons.cleaning_services_rounded,
    'ti-tool': Icons.build_rounded,
    'ti-chef-hat': Icons.restaurant_rounded,
    'ti-baby-carriage': Icons.child_care_rounded,
  };

  static const Map<String, Color> tileColors = {
    'ti-bulb': Color(0xFFFCE9C7),
    'ti-droplet': Color(0xFFD8E9F7),
    'ti-hammer': Color(0xFFF6DFC8),
    'ti-brush': Color(0xFFF9DCE2),
    'ti-home-2': Color(0xFFE3DAF3),
    'ti-heart-handshake': Color(0xFFD9EFE0),
    'ti-steering-wheel': Color(0xFFD8E9F7),
    'ti-plant-2': Color(0xFFDCEFDB),
    'ti-spray': Color(0xFFD7F0F1),
    'ti-tool': Color(0xFFE3DAF3),
    'ti-chef-hat': Color(0xFFF6DFC8),
    'ti-baby-carriage': Color(0xFFF9DCE2),
  };

  static const Map<String, Color> tileIconColors = {
    'ti-bulb': Color(0xFFB9791A),
    'ti-droplet': Color(0xFF1D6FA5),
    'ti-hammer': Color(0xFFB9611A),
    'ti-brush': Color(0xFFC24568),
    'ti-home-2': Color(0xFF6A4EA8),
    'ti-heart-handshake': AppColors.green700,
    'ti-steering-wheel': Color(0xFF1D6FA5),
    'ti-plant-2': AppColors.green700,
    'ti-spray': Color(0xFF1D8A8C),
    'ti-tool': Color(0xFF6A4EA8),
    'ti-chef-hat': Color(0xFFB9611A),
    'ti-baby-carriage': Color(0xFFC24568),
  };

  static IconData iconFor(String key) => icons[key] ?? Icons.build_rounded;
  static Color tileColorFor(String key) => tileColors[key] ?? AppColors.mist;
  static Color tileIconColorFor(String key) => tileIconColors[key] ?? AppColors.slate;
}
