# Quick Start Guide

## Important: Firebase Configuration Required

Before running this app, you need to configure Firebase:

1. **Get Firebase Configuration:**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create or select your project
   - Go to Project Settings > General > Your apps
   - Add a web app or select existing one
   - Copy the Firebase configuration object

2. **Update Configuration:**
   - Open `lib/firebase_config.dart`
   - Replace placeholder values with your actual Firebase config:
     - apiKey
     - authDomain
     - projectId
     - storageBucket
     - messagingSenderId
     - appId

3. **Database URL:**
   - The app is configured to use: `https://feature-flags.firebaseio.com/`
   - Make sure this URL matches your Firebase project or update it in the config

4. **Run the App:**
   ```bash
   flutter pub get
   flutter run -d chrome
   ```

## Features:
- ✅ Real-time data synchronization
- ✅ Write/Push/Delete operations
- ✅ Dynamic path switching
- ✅ Live data display
- ✅ Responsive web interface

## Database Operations:
- **Write Data:** Set key-value pairs at specified path
- **Push Data:** Add data with auto-generated keys
- **Delete Data:** Remove data at specified path
- **Real-time Listening:** Automatic updates when data changes