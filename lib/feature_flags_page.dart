import 'package:flutter/material.dart';

import 'feature_flags_service.dart';

class FeatureFlagsPage extends StatefulWidget {
  const FeatureFlagsPage({super.key});

  @override
  _FeatureFlagsPageState createState() => _FeatureFlagsPageState();
}

class _FeatureFlagsPageState extends State<FeatureFlagsPage> {
  Map<String, bool> _featureFlags = {};
  bool _isLoading = true;

  // Feature descriptions for better UX
  final Map<String, FeatureInfo> _featureInfo = {
    'feature1': FeatureInfo(
      title: 'Feature 1',
      description: 'Main feature toggle - shows/hides primary feature content',
      color: Colors.blue,
    ),
    'newUserInterface': FeatureInfo(
      title: 'New User Interface',
      description: 'Enables the modern UI design with enhanced user experience',
      color: Colors.purple,
    ),
    'darkMode': FeatureInfo(
      title: 'Dark Mode',
      description: 'Toggles between light and dark theme',
      color: Colors.grey,
    ),
    'advancedSearch': FeatureInfo(
      title: 'Advanced Search',
      description: 'Enables advanced search functionality with filters',
      color: Colors.green,
    ),
    'notifications': FeatureInfo(
      title: 'Notifications',
      description: 'Push notifications and in-app alerts',
      color: Colors.orange,
    ),
    'betaFeatures': FeatureInfo(
      title: 'Beta Features',
      description: 'Access to experimental features and early previews',
      color: Colors.red,
    ),
  };

  @override
  void initState() {
    super.initState();
    _initializeFeatureFlags();
    _listenToFeatureFlags();
  }

  Future<void> _initializeFeatureFlags() async {
    await FeatureFlagsService.initializeFeatureFlags();
  }

  void _listenToFeatureFlags() {
    FeatureFlagsService.listenToFeatureFlags().listen(
      (Map<String, bool> flags) {
        setState(() {
          _featureFlags = flags;
          _isLoading = false;
        });
      },
      onError: (error) {
        print('Error listening to feature flags: $error');
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading feature flags: $error')),
        );
      },
    );
  }

  Future<void> _toggleFeature(String flagName) async {
    try {
      await FeatureFlagsService.toggleFeatureFlag(flagName);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${_featureInfo[flagName]?.title ?? flagName} ${!_featureFlags[flagName]! ? 'enabled' : 'disabled'}'),
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error toggling feature: $e')),
      );
    }
  }

  Future<void> _resetToDefaults() async {
    try {
      await FeatureFlagsService.resetToDefaults();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All features reset to defaults')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error resetting features: $e')),
      );
    }
  }

  Widget _buildFeatureToggle(String flagName, bool isEnabled) {
    final info = _featureInfo[flagName] ??
        FeatureInfo(
          title: flagName,
          description: 'Custom feature flag',
          color: Colors.blue,
        );

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Feature Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: info.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isEnabled ? Icons.toggle_on : Icons.toggle_off,
                color: isEnabled ? info.color : Colors.grey,
                size: 32,
              ),
            ),
            SizedBox(width: 16),

            // Feature Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isEnabled ? Colors.black87 : Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    info.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isEnabled
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isEnabled ? 'ENABLED' : 'DISABLED',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isEnabled ? Colors.green[700] : Colors.red[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Toggle Switch
            Switch(
              value: isEnabled,
              onChanged: (value) => _toggleFeature(flagName),
              activeColor: info.color,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoContent() {
    return Card(
      margin: EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Live Demo Features',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),

            // Feature 1 Demo
            if (_featureFlags['feature1'] == true) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue),
                ),
                child: Column(
                  children: [
                    Icon(Icons.star, color: Colors.blue, size: 32),
                    SizedBox(height: 8),
                    Text(
                      '🎉 Feature 1 is ACTIVE!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                    Text(
                      'This content appears when feature1 is enabled',
                      style: TextStyle(color: Colors.blue[600]),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
            ],

            // New UI Demo
            if (_featureFlags['newUserInterface'] == true) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.purple),
                ),
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.purple, size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'New UI Elements Loaded',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple[700],
                            ),
                          ),
                          Text(
                            'Enhanced design components are now visible',
                            style: TextStyle(color: Colors.purple[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
            ],

            // Dark Mode Demo
            if (_featureFlags['darkMode'] == true) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.dark_mode, color: Colors.white, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'Dark Mode Activated',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
            ],

            // Advanced Search Demo
            if (_featureFlags['advancedSearch'] == true) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.search, color: Colors.green, size: 24),
                        SizedBox(width: 12),
                        Text(
                          'Advanced Search Available',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search with advanced filters...',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.filter_list),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
            ],

            // Notifications Demo
            if (_featureFlags['notifications'] == true) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  children: [
                    Icon(Icons.notifications_active,
                        color: Colors.orange, size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Notifications Enabled - You\'ll receive real-time updates',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
            ],

            // Beta Features Demo
            if (_featureFlags['betaFeatures'] == true) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.science, color: Colors.red, size: 24),
                        SizedBox(width: 12),
                        Text(
                          'Beta Features Unlocked',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Experimental features are now available for testing',
                      style: TextStyle(color: Colors.red[600]),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
            ],

            // Show message when no features are enabled
            if (_featureFlags.values.every((flag) => !flag)) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(Icons.toggle_off, color: Colors.grey, size: 48),
                    SizedBox(height: 16),
                    Text(
                      'No Features Enabled',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Enable feature flags above to see demo content appear here in real-time!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feature Flags Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetToDefaults,
            tooltip: 'Reset to Defaults',
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Row(
              children: [
                // Left Panel - Feature Flags Controls
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        color: Colors.blue.withOpacity(0.1),
                        child: Column(
                          children: [
                            Text(
                              'Feature Flags Control Panel',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Toggle features on/off and see real-time changes',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                'Firebase Path: /feature-flags',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: _featureFlags.entries
                              .map((entry) =>
                                  _buildFeatureToggle(entry.key, entry.value))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                // Right Panel - Demo Content
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: _buildDemoContent(),
                  ),
                ),
              ],
            ),
    );
  }
}

class FeatureInfo {
  final String title;
  final String description;
  final Color color;

  FeatureInfo({
    required this.title,
    required this.description,
    required this.color,
  });
}
