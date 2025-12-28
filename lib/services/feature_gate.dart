import 'feature_flag_service.dart';

typedef FeatureAction = void Function();

class FeatureGate {
  final FeatureFlagService service;

  FeatureGate(this.service);
// userGroup => al apps that can has the feature
// userGroup ==> feature group like milestone
//// where sub features grouped in flow
  void run(String feature, String userGroup, FeatureAction action) {
    if (service.isEnabled(feature, userGroup)) {
      action();
    } else {
      print("Feature $feature is disabled for $userGroup");
    }
  }

  /// Run action with custom disabled callback
  void runWithCallback({
    required String feature,
    required String userGroup,
    required FeatureAction onEnabled,
    FeatureAction? onDisabled,
  }) {
    if (service.isEnabled(feature, userGroup)) {
      onEnabled();
    } else {
      if (onDisabled != null) {
        onDisabled();
      } else {
        print("Feature $feature is disabled for $userGroup");
      }
    }
  }

  /// Check if feature is enabled without executing
  bool isEnabled(String feature, String userGroup) {
    return service.isEnabled(feature, userGroup);
  }
}
