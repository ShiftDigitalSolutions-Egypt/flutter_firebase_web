import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'firebase_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _pathController =
      TextEditingController(text: 'test');

  Map<String, dynamic> _realtimeData = {};
  bool _isListening = false;
  late DatabaseReference _databaseRef;

  @override
  void initState() {
    super.initState();
    _databaseRef = FirebaseService.getReference(_pathController.text);
    _startListening();
  }

  void _startListening() {
    if (!_isListening) {
      setState(() {
        _isListening = true;
      });

      FirebaseService.listenToData(_pathController.text).listen(
        (DatabaseEvent event) {
          if (event.snapshot.value != null) {
            setState(() {
              if (event.snapshot.value is Map) {
                _realtimeData =
                    Map<String, dynamic>.from(event.snapshot.value as Map);
              } else {
                _realtimeData = {'value': event.snapshot.value};
              }
            });
          } else {
            setState(() {
              _realtimeData = {};
            });
          }
        },
        onError: (error) {
          print('Error listening to data: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error listening to data: $error')),
          );
        },
      );
    }
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
      _realtimeData = {};
    });
  }

  Future<void> _writeData() async {
    if (_keyController.text.isNotEmpty && _valueController.text.isNotEmpty) {
      try {
        Map<String, dynamic> data = {
          _keyController.text: _valueController.text,
        };
        await FirebaseService.writeData(_pathController.text, data);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data written successfully!')),
        );

        _keyController.clear();
        _valueController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error writing data: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both key and value')),
      );
    }
  }

  Future<void> _pushData() async {
    if (_valueController.text.isNotEmpty) {
      try {
        Map<String, dynamic> data = {
          'message': _valueController.text,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        };
        String? key =
            await FirebaseService.pushData(_pathController.text, data);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data pushed with key: $key')),
        );

        _valueController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error pushing data: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a value')),
      );
    }
  }

  Future<void> _deleteData() async {
    try {
      await FirebaseService.deleteData(_pathController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting data: $e')),
      );
    }
  }

  void _changePath() {
    _stopListening();
    _databaseRef = FirebaseService.getReference(_pathController.text);
    _startListening();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Realtime Database Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Left Panel - Controls
            Expanded(
              flex: 1,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Database Controls',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 20),

                      // Path Input
                      TextField(
                        controller: _pathController,
                        decoration: InputDecoration(
                          labelText: 'Database Path',
                          border: OutlineInputBorder(),
                          hintText: 'e.g., users, messages, test',
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _changePath,
                        child: Text('Change Path'),
                      ),
                      SizedBox(height: 20),

                      // Key-Value Input
                      TextField(
                        controller: _keyController,
                        decoration: InputDecoration(
                          labelText: 'Key',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _valueController,
                        decoration: InputDecoration(
                          labelText: 'Value',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Action Buttons
                      ElevatedButton(
                        onPressed: _writeData,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        child: Text('Write Data'),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _pushData,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        child: Text('Push Data (Auto Key)'),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _deleteData,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: Text('Delete Path Data'),
                      ),
                      SizedBox(height: 20),

                      // Listening Status
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _isListening
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _isListening
                              ? 'Listening to: ${_pathController.text}'
                              : 'Not listening',
                          style: TextStyle(
                            color: _isListening
                                ? Colors.green.shade800
                                : Colors.red.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(width: 16),

            // Right Panel - Real-time Data Display
            Expanded(
              flex: 1,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Real-time Data',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: SingleChildScrollView(
                            child: _realtimeData.isEmpty
                                ? Text(
                                    'No data available at path: ${_pathController.text}',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey.shade600,
                                    ),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children:
                                        _realtimeData.entries.map((entry) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${entry.key}:',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue.shade700,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                '${entry.value}',
                                                style: TextStyle(
                                                  fontFamily: 'monospace',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Database URL: https://feature-flags.firebaseio.com/',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    _pathController.dispose();
    super.dispose();
  }
}
