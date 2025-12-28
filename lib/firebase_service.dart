import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  static final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Get reference to a specific path
  static DatabaseReference getReference(String path) {
    return _database.child(path);
  }

  // Write data to Firebase
  static Future<void> writeData(String path, dynamic data) async {
    try {
      await _database.child(path).set(data);
    } catch (e) {
      print('Error writing data: $e');
      rethrow;
    }
  }

  // Read data from Firebase once
  static Future<DataSnapshot> readData(String path) async {
    try {
      DatabaseEvent event = await _database.child(path).once();
      return event.snapshot;
    } catch (e) {
      print('Error reading data: $e');
      rethrow;
    }
  }

  // Listen to data changes
  static Stream<DatabaseEvent> listenToData(String path) {
    return _database.child(path).onValue;
  }

  // Update data at specific path
  static Future<void> updateData(
      String path, Map<String, dynamic> updates) async {
    try {
      await _database.child(path).update(updates);
    } catch (e) {
      print('Error updating data: $e');
      rethrow;
    }
  }

  // Delete data at specific path
  static Future<void> deleteData(String path) async {
    try {
      await _database.child(path).remove();
    } catch (e) {
      print('Error deleting data: $e');
      rethrow;
    }
  }

  // Push new data (auto-generated key)
  static Future<String?> pushData(
      String path, Map<String, dynamic> data) async {
    try {
      DatabaseReference newRef = _database.child(path).push();
      await newRef.set(data);
      return newRef.key;
    } catch (e) {
      print('Error pushing data: $e');
      rethrow;
    }
  }
}
