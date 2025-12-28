import 'package:flutter/material.dart';
import 'services/feature_flag_service.dart';
import 'services/feature_gate.dart';
import 'widgets/feature_widget.dart';

class DemoPage extends StatefulWidget {
  final FeatureFlagService flagService;
  final FeatureGate gate;

  const DemoPage({super.key, required this.flagService, required this.gate});

  @override
  // ignore: library_private_types_in_public_api
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  String _selectedUserGroup = 'hse';
  final List<String> _userGroups = ['hse', 'kz'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feature Flags Demo'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Group Selector
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select User Group:',
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
                                    ? Colors.green 
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
            ),
            
            SizedBox(height: 20),

            // Demo Section
            Text(
              'Demo for User Group: ${_selectedUserGroup.toUpperCase()}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            
            SizedBox(height: 20),

            // Function-based Feature Demo (FeatureGate)
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Function-based Features (FeatureGate)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        widget.gate.run("feature1", _selectedUserGroup, () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Feature1 executed for $_selectedUserGroup"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        });
                      },
                      child: Text("Run Feature1 Action"),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        widget.gate.run("feature2", _selectedUserGroup, () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Feature2 executed for $_selectedUserGroup"),
                              backgroundColor: Colors.blue,
                            ),
                          );
                        });
                      },
                      child: Text("Run Feature2 Action"),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Widget-based Feature Demo (FeatureWidget)
            Text(
              'Widget-based Features (FeatureWidget)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            
            SizedBox(height: 12),

            // Feature1 Widget Demo
            FeatureWidgetStream(
              feature: "feature1",
              userGroup: _selectedUserGroup,
              service: widget.flagService,
              fallback: Card(
                color: Colors.red[50],
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(Icons.block, color: Colors.red, size: 32),
                      SizedBox(height: 8),
                      Text(
                        "❌ Feature1 is DISABLED",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700],
                        ),
                      ),
                      Text(
                        "Feature1 is disabled for $_selectedUserGroup",
                        style: TextStyle(color: Colors.red[600]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              child: Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(Icons.star, color: Colors.blue, size: 32),
                      SizedBox(height: 8),
                      Text(
                        "🎉 Feature1 is ENABLED!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                      Text(
                        "This content is visible for $_selectedUserGroup because feature1 is enabled",
                        style: TextStyle(color: Colors.blue[600]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 12),

            // Feature2 Widget Demo
            FeatureWidgetStream(
              feature: "feature2",
              userGroup: _selectedUserGroup,
              service: widget.flagService,
              child: Card(
                color: Colors.green[50],
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 32),
                      SizedBox(height: 8),
                      Text(
                        "✅ Feature2 is ACTIVE!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      Text(
                        "Advanced functionality available for $_selectedUserGroup",
                        style: TextStyle(color: Colors.green[600]),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Feature2 button clicked!")),
                          );
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: Text("Feature2 Button"),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Status Information
            Card(
              color: Colors.grey[50],
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Feature Status for ${_selectedUserGroup.toUpperCase()}:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Feature1: ${widget.flagService.isEnabled("feature1", _selectedUserGroup) ? "ENABLED" : "DISABLED"}'),
                    Text('Feature2: ${widget.flagService.isEnabled("feature2", _selectedUserGroup) ? "ENABLED" : "DISABLED"}'),
                    SizedBox(height: 12),
                    Text(
                      'Note: Switch between user groups to see different behaviors!',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}