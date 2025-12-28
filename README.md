# Flutter Firebase Realtime Database Web App

A Flutter web application that connects to Firebase Realtime Database for real-time data synchronization.

## Features

- Real-time data listening and updates
- Write data to Firebase Realtime Database
- Push data with auto-generated keys
- Delete data from specific paths
- Dynamic path switching
- Responsive web interface

## Setup Instructions

### Prerequisites

- Flutter SDK (latest stable version)
- A Firebase project with Realtime Database enabled

### Firebase Configuration

1. **Create a Firebase Project:**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project or use existing one
   - Enable Realtime Database

2. **Configure Firebase for Web:**
   - In your Firebase project, go to Project Settings
   - Add a web app to your project
   - Copy the Firebase configuration

3. **Update Firebase Configuration:**
   - Open `lib/firebase_config.dart`
   - Replace the placeholder values with your actual Firebase configuration:
   ```dart
   static const FirebaseOptions web = FirebaseOptions(
     apiKey: 'your-actual-api-key',
     authDomain: 'your-project.firebaseapp.com',
     databaseURL: 'https://feature-flags.firebaseio.com/', // Your provided URL
     projectId: 'your-project-id',
     storageBucket: 'your-project.appspot.com',
     messagingSenderId: 'your-sender-id',
     appId: 'your-app-id',
   );
   ```

### Database URL Configuration

This app is configured to use the Firebase Realtime Database at:
```
https://feature-flags.firebaseio.com/
```

Make sure your Firebase project has access to this database URL, or update the URL in `firebase_config.dart` if needed.

### Running the Application

1. **Install Dependencies:**
   ```bash
   cd flutter_firebase_web
   flutter pub get
   ```

2. **Run on Web:**
   ```bash
   flutter run -d chrome
   ```

3. **Build for Production:**
   ```bash
   flutter build web
   ```

## Usage

### Interface Overview

The application has two main panels:

#### Left Panel - Database Controls
- **Database Path:** Enter the path in your Firebase database (e.g., 'users', 'messages', 'test')
- **Key/Value Input:** Enter key-value pairs to write to the database
- **Action Buttons:**
  - **Write Data:** Writes key-value pair to the specified path
  - **Push Data:** Pushes data with auto-generated key and timestamp
  - **Delete Path Data:** Removes all data at the specified path

#### Right Panel - Real-time Data Display
- Shows live data from the Firebase Realtime Database
- Updates automatically when data changes
- Displays the current database URL being used

### Example Operations

1. **Write Simple Data:**
   - Path: `test`
   - Key: `name`
   - Value: `John Doe`
   - Click "Write Data"

2. **Push Message:**
   - Path: `messages`
   - Value: `Hello World!`
   - Click "Push Data" (creates auto-generated key with timestamp)

3. **Listen to Different Paths:**
   - Change the "Database Path" field
   - Click "Change Path" to start listening to new location

## Database Structure

The app works with any Firebase Realtime Database structure. Example:

```json
{
  "test": {
    "name": "John Doe",
    "email": "john@example.com"
  },
  "messages": {
    "-N1234567890": {
      "message": "Hello World!",
      "timestamp": 1640995200000
    }
  }
}
```

## Security Rules

Make sure your Firebase Realtime Database rules allow read/write access. For development, you can use:

```json
{
  "rules": {
    ".read": true,
    ".write": true
  }
}
```

**Note:** For production, implement proper security rules based on your authentication requirements.

## Dependencies

- `firebase_core`: ^2.24.2 - Firebase core functionality
- `firebase_database`: ^10.4.0 - Realtime Database SDK
- `flutter`: SDK - Flutter framework

## Troubleshooting

### Common Issues

1. **Firebase Configuration Error:**
   - Ensure all Firebase configuration values are correctly set in `firebase_config.dart`
   - Verify that the web app is properly registered in Firebase Console

2. **Permission Denied:**
   - Check Firebase Database security rules
   - Ensure read/write permissions are properly configured

3. **Network Issues:**
   - Verify internet connection
   - Check if Firebase services are accessible from your network

### Development Tips

- Use browser developer tools to monitor network requests and console logs
- Enable Flutter web debugging for better error messages
- Check Firebase Console for database activity and errors

## License

This project is open source and available under the MIT License.