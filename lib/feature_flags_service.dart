import 'package:firebase_database/firebase_database.dart';
import 'firebase_service.dart';

class FeatureFlagsService {
  static const String _featureFlagsPath = 'feature-flags';

  // Default feature flags
  static const Map<String, bool> _defaultFlags = {
    'feature1': false,
    'newUserInterface': false,
    'darkMode': false,
    'advancedSearch': false,
    'notifications': false,
    'betaFeatures': false,
  };

  // Get a specific feature flag value
  static Future<bool> getFeatureFlag(String flagName) async {
    try {
      DataSnapshot snapshot =
          await FirebaseService.readData('$_featureFlagsPath/$flagName');
      if (snapshot.exists && snapshot.value is bool) {
        return snapshot.value as bool;
      }
      return _defaultFlags[flagName] ?? false;
    } catch (e) {
      print('Error getting feature flag $flagName: $e');
      return _defaultFlags[flagName] ?? false;
    }
  }

  // Set a specific feature flag value
  static Future<void> setFeatureFlag(String flagName, bool value) async {
    try {
      await FirebaseService.writeData('$_featureFlagsPath/$flagName', value);
    } catch (e) {
      print('Error setting feature flag $flagName: $e');
      rethrow;
    }
  }

  // Get all feature flags
  static Future<Map<String, bool>> getAllFeatureFlags() async {
    try {
      DataSnapshot snapshot = await FirebaseService.readData(_featureFlagsPath);

      Map<String, bool> flags = Map.from(_defaultFlags);

      if (snapshot.exists && snapshot.value is Map) {
        Map<dynamic, dynamic> firebaseFlags =
            snapshot.value as Map<dynamic, dynamic>;
        firebaseFlags.forEach((key, value) {
          if (key is String && value is bool) {
            flags[key] = value;
          }
        });
      }

      return flags;
    } catch (e) {
      print('Error getting all feature flags: $e');
      return Map.from(_defaultFlags);
    }
  }

  // Listen to all feature flags changes
  static Stream<Map<String, bool>> listenToFeatureFlags() {
    return FirebaseService.listenToData(_featureFlagsPath)
        .map((DatabaseEvent event) {
      Map<String, bool> flags = Map.from(_defaultFlags);

      if (event.snapshot.exists && event.snapshot.value is Map) {
        Map<dynamic, dynamic> firebaseFlags =
            event.snapshot.value as Map<dynamic, dynamic>;
        firebaseFlags.forEach((key, value) {
          if (key is String && value is bool) {
            flags[key] = value;
          }
        });
      }

      return flags;
    });
  }

  // Listen to a specific feature flag
  static Stream<bool> listenToFeatureFlag(String flagName) {
    return FirebaseService.listenToData('$_featureFlagsPath/$flagName')
        .map((DatabaseEvent event) {
      if (event.snapshot.exists && event.snapshot.value is bool) {
        return event.snapshot.value as bool;
      }
      return _defaultFlags[flagName] ?? false;
    });
  }

  // Initialize default feature flags in Firebase (if they don't exist)
  static Future<void> initializeFeatureFlags() async {
    try {
      Map<String, bool> currentFlags = await getAllFeatureFlags();

      // Add any missing default flags
      Map<String, dynamic> updates = {};
      _defaultFlags.forEach((key, defaultValue) {
        if (!currentFlags.containsKey(key)) {
          updates[key] = defaultValue;
        }
      });

      if (updates.isNotEmpty) {
        await FirebaseService.updateData(_featureFlagsPath, updates);
      }
    } catch (e) {
      print('Error initializing feature flags: $e');
    }
  }

  // Toggle a feature flag
  static Future<void> toggleFeatureFlag(String flagName) async {
    try {
      bool currentValue = await getFeatureFlag(flagName);
      await setFeatureFlag(flagName, !currentValue);
    } catch (e) {
      print('Error toggling feature flag $flagName: $e');
      rethrow;
    }
  }

  // Reset all flags to default values
  static Future<void> resetToDefaults() async {
    try {
      await FirebaseService.writeData(_featureFlagsPath, _defaultFlags);
    } catch (e) {
      print('Error resetting feature flags: $e');
      rethrow;
    }
  }
}
