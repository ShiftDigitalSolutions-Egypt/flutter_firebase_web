import 'services/feature_flag_service.dart';

class FeatureFlagsInitializer {
  static Future<void> initializeSampleData(FeatureFlagService service) async {
    // Set up the exact structure from requirements.md
    
    // Feature1 configuration
    await service.setFeatureFlag('feature1', 'hse', true);
    await service.setFeatureFlag('feature1', 'kz', false);
    
    // Feature2 configuration
    await service.setFeatureFlag('feature2', 'hse', false);
    // Note: feature2.kz is not set, so it will be enabled by default
    
    print('Sample feature flags initialized!');
    print('feature1.hse = true');
    print('feature1.kz = false'); 
    print('feature2.hse = false');
    print('feature2.kz = enabled by default (not set)');
  }
  
  static Map<String, dynamic> getSampleStructure() {
    return {
      "feature1": {
        "hse": true,
        "kz": false
      },
      "feature2": {
        "hse": false
      }
    };
  }
}