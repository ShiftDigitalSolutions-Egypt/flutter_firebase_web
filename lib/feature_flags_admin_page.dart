import 'package:flutter/material.dart';
import 'services/feature_flag_service.dart';

class FeatureFlagsPage extends StatefulWidget {
  final FeatureFlagService flagService;

  const FeatureFlagsPage({super.key, required this.flagService});

  @override
  _FeatureFlagsPageState createState() => _FeatureFlagsPageState();
}

class _FeatureFlagsPageState extends State<FeatureFlagsPage> {
  String _selectedUserGroup = 'hse';
  bool _isLoading = true;

  var _userGroups = <dynamic>{};
  List _features = [];

  @override
  void initState() {
    super.initState();
    _loadFlags();
    _listenToFlags();

    _userGroups =
        widget.flagService.getAvailableUserGroups(); // Load once at startup
  }

  Future<void> _loadFlags() async {
    await widget.flagService.loadFlags();
    setState(() {
      _isLoading = false;
    });
    _features = widget.flagService.flags.keys.toList();
  }

  void _listenToFlags() {
    widget.flagService.listenToFlags().listen((flags) {
      setState(() {
        // Trigger rebuild when flags change
      });
    });
  }

  Future<void> _toggleFeature(String feature, String userGroup) async {
    bool currentValue = widget.flagService.isEnabled(feature, userGroup);
    await widget.flagService.setFeatureFlag(feature, userGroup, !currentValue);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '$feature for $userGroup: ${!currentValue ? 'ENABLED' : 'DISABLED'}'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildUserGroupSelector() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select User Group',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Row(
              children: _userGroups.map((group) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedUserGroup == group
                            ? Colors.blue
                            : Colors.grey[300],
                        foregroundColor: _selectedUserGroup == group
                            ? Colors.white
                            : Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedUserGroup = group;
                        });
                      },
                      child: Text(group.toUpperCase()),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(String feature) {
    bool isEnabled = widget.flagService.isEnabled(feature, _selectedUserGroup);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  feature,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  activeColor: isEnabled ? Colors.green : Colors.red,
                  value: isEnabled,
                  onChanged: (value) =>
                      _toggleFeature(feature, _selectedUserGroup),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Current status for $_selectedUserGroup: ${isEnabled ? 'ENABLED' : 'DISABLED'}',
              style: TextStyle(
                color: isEnabled ? Colors.green : Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'All Groups Status:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ..._userGroups.map((group) {
              bool groupEnabled = widget.flagService.isEnabled(feature, group);
              return Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      child: Text(
                        group.toUpperCase(),
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: groupEnabled
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        groupEnabled ? 'ENABLED' : 'DISABLED',
                        style: TextStyle(
                          color: groupEnabled
                              ? Colors.green[700]
                              : Colors.red[700],
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            groupEnabled ? Colors.red : Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: Size(80, 30),
                      ),
                      onPressed: () => _toggleFeature(feature, group),
                      child: Text(groupEnabled ? 'Disable' : 'Enable'),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDatabaseStructure() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Firebase Database Structure',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '''feature_flags: {
  "feature1": {
    "hse": ${widget.flagService.isEnabled('feature1', 'hse')},
    "kz": ${widget.flagService.isEnabled('feature1', 'kz')}
  },
  "feature2": {
    "hse": ${widget.flagService.isEnabled('feature2', 'hse')},
    "kz": ${widget.flagService.isEnabled('feature2', 'kz')}
  }
}''',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Rules:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('• If feature not defined → enabled by default'),
            Text('• If user group not defined → enabled by default'),
            Text('• Explicit false → disabled'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Feature Flags Admin'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Feature Flags Admin'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildUserGroupSelector(),
            Text(
              'Manage Features for ${_selectedUserGroup.toUpperCase()}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
            SizedBox(height: 16),
            ..._features.map((feature) => _buildFeatureCard(feature)).toList(),
            _buildDatabaseStructure(),
          ],
        ),
      ),
    );
  }
}
