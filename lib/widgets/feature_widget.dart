import 'package:flutter/material.dart';
import '../services/feature_flag_service.dart';

class FeatureWidget extends StatelessWidget {
  final String feature;
  final String userGroup;
  final Widget child;
  final FeatureFlagService service;

  const FeatureWidget({
    super.key,
    required this.feature,
    required this.userGroup,
    required this.child,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return service.isEnabled(feature, userGroup)
        ? child
        : const SizedBox.shrink();
  }
}

/// StreamBuilder version for real-time updates
class FeatureWidgetStream extends StatelessWidget {
  final String feature;
  final String userGroup;
  final Widget child;
  final FeatureFlagService service;
  final Widget? fallback;

  const FeatureWidgetStream({
    super.key,
    required this.feature,
    required this.userGroup,
    required this.child,
    required this.service,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: service.listenToFlags(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return service.isEnabled(feature, userGroup)
              ? child
              : (fallback ?? const SizedBox.shrink());
        }
        return const SizedBox.shrink();
      },
    );
  }
}