import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class FeatureFlagService {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref("feature_flags");

  Map<String, dynamic> _flags = {};
  Map<String, dynamic> get flags => _flags;

  // Stream subscription to keep listening for changes
  StreamSubscription<DatabaseEvent>? _subscription;

  //  get flags => _flags;

  /// Load feature flags once from Firebase and start listening for changes
  Future<void> loadFlags() async {
    try {
      print("🔍 Attempting to load feature flags from Firebase...");
      final snapshot = await _ref.get();
      if (snapshot.exists) {
        _flags = Map<String, dynamic>.from(snapshot.value as Map);
        print("✅ Feature flags loaded successfully: $_flags");
        print("✅ Feature flags Keys loaded successfully: ${_flags.keys}");
        print(
            "✅ Feature flags Keys loaded successfully: ${_flags.keys.map((key) => '$key: ${_flags[key]}')}");
      } else {
        print("⚠️ No feature flags found in Firebase, using defaults");
        _setDefaultFlags();
      }

      // Start listening for real-time changes
      startListening();
    } catch (e) {
      print("❌ Error loading feature flags: $e");

      if (e.toString().contains('permission-denied')) {
        print(
            "🔒 Firebase permission denied. Please update your Firebase Realtime Database rules.");
        print(
            "📝 Go to Firebase Console > Realtime Database > Rules and allow read access to 'feature_flags'");
      }

      // Set default flags so app can continue working
      _setDefaultFlags();
    }
  }

  /// Start listening to real-time changes
  void startListening() {
    if (_subscription != null) {
      print("🔄 Already listening to feature flags changes");
      return;
    }

    print("🔄 Starting to listen for feature flags changes...");
    _subscription = _ref.onValue.listen(
      (event) {
        if (event.snapshot.exists) {
          final newFlags =
              Map<String, dynamic>.from(event.snapshot.value as Map);
          _flags = newFlags;
          print("🔄 Feature flags updated in real-time: $_flags");
          print("🔄 Updated flags keys: ${_flags.keys}");
        } else {
          print("⚠️ No data in real-time update");
        }
      },
      onError: (error) {
        print("❌ Real-time listener error: $error");
      },
    );
  }

  /// Stop listening to changes
  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
    print("🛑 Stopped listening to feature flags changes");
  }

  /// Set default feature flags when Firebase is unavailable
  void _setDefaultFlags() {
    _flags = {
      'new_ui_enabled': false,
      'payment_gateway_v2': false,
      'debug_mode': true,
      'social_login': false,
      'advanced_analytics': false,
      'milestone': {
        'default': true,
        'premium': false,
        'basic': false,
      }
    };
    print("🔧 Using default feature flags: $_flags");
  }

  /// Check if feature is enabled for userGroup
  bool isEnabled(String feature, String userGroup) {
    print("🔍 Checking feature: '$feature' for userGroup: '$userGroup'");

    final featureConfig = _flags[feature];
    print("🔧 Feature config for '$feature': $featureConfig");

    if (featureConfig == null) {
      print(
          "⚠️ Feature '$feature' not defined → returning true (enabled by default)");
      return true;
    }

    print("📋 Feature '$feature' exists, checking group '$userGroup'...");
    final groupConfig = (featureConfig as Map)[userGroup];
    print("🎯 Group config for '$userGroup': $groupConfig");

    if (groupConfig == null) {
      print(
          "⚠️ No explicit group setting for '$userGroup' → returning true (enabled by default)");
      return true;
    }

    final result = groupConfig == true;
    print("✅ Final result for '$feature'.'$userGroup': $result");
    return result;
  }

  /// Simple feature check without user groups (for boolean flags)
  bool isFeatureEnabled(String feature) {
    // If the feature is a boolean directly
    if (_flags[feature] is bool) {
      return _flags[feature] as bool;
    }

    // If the feature has nested configuration, check if any group is enabled
    if (_flags[feature] is Map) {
      final featureMap = _flags[feature] as Map;
      return featureMap.values.any((value) => value == true);
    }

    return false; // Default to false for safety
  }

  /// Get all flags for debugging/admin purposes
  Map<String, dynamic> getAllFlags() {
    return Map.from(_flags);
  }

  /// Listen to real-time changes in feature flags
  Stream<Map<String, dynamic>> listenToFlags() {
    return _ref.onValue.map((event) {
      if (event.snapshot.exists) {
        final newFlags = Map<String, dynamic>.from(event.snapshot.value as Map);
        _flags = newFlags;
        print("🔄 Feature flags updated via stream: $_flags");
        print("🔄 Updated flags keys: ${_flags.keys}");
        return Map<String, dynamic>.from(_flags);
      } else {
        print("⚠️ No data in stream event, keeping current flags");
        return Map<String, dynamic>.from(_flags);
      }
    }).handleError((error) {
      print("❌ Stream error: $error");
      // Don't return here, let the stream continue
    });
  }

  /// Update a specific feature flag for a user group (for admin/testing)
  Future<void> setFeatureFlag(
      String feature, String userGroup, bool enabled) async {
    try {
      await _ref.child(feature).child(userGroup).set(enabled);
      print("✅ Feature flag updated: $feature.$userGroup = $enabled");
    } catch (e) {
      print("❌ Error updating feature flag $feature.$userGroup: $e");
      throw e; // Re-throw so caller can handle
    }
  }

  /// Get all available user groups
  Set<String> getAvailableUserGroups() {
    Set<String> groups = {};
    _flags.forEach((feature, config) {
      if (config is Map) {
        groups.addAll(config.keys.cast<String>());
      }
    });
    return groups;
  }

  /// Get all available features
  Set<String> getAvailableFeatures() {
    return _flags.keys.toSet();
  }
}
