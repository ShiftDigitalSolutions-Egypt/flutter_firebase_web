# Flutter Firebase Web App Architecture Diagram

## System Architecture Overview

```mermaid
graph TD
    A[User Interface] --> B[Flutter Web Application]
    B --> C[Firebase SDK]
    C --> D[Firebase Realtime Database]
    
    subgraph "Flutter Application Structure"
        E[main.dart] --> F[MainNavigation]
        F --> G[HomePage - Database Demo]
        F --> H[FeatureFlagsPage - Feature Flags]
        F --> I[DemoPage - Feature Demo]
        
        J[FeatureFlagService] --> K[Firebase Database]
        L[FeatureGate] --> J
        M[FeatureWidget] --> J
        
        G --> N[Firebase Service]
        N --> O[Realtime Database Operations]
    end
    
    subgraph "Firebase Services"
        D --> P[Real-time Data Sync]
        D --> Q[CRUD Operations]
        D --> R[Path-based Data Structure]
    end

    style A fill:#e1f5fe
    style B fill:#f3e5f5
    style D fill:#fff3e0
    style J fill:#e8f5e8
```

## Application Flow Diagram

```mermaid
sequenceDiagram
    participant U as User
    participant UI as Flutter UI
    participant FS as Firebase Service
    participant FFS as Feature Flag Service
    participant FDB as Firebase Realtime DB

    U->>UI: Launch Application
    UI->>FS: Initialize Firebase
    UI->>FFS: Load Feature Flags
    FFS->>FDB: Fetch feature flags data
    FDB-->>FFS: Return flags configuration
    FFS-->>UI: Flags loaded
    
    U->>UI: Navigate to Database Demo
    UI->>FS: Setup database listener
    FS->>FDB: Listen to database path
    FDB-->>FS: Real-time data updates
    FS-->>UI: Display live data
    
    U->>UI: Write data (key/value)
    UI->>FS: Write to database
    FS->>FDB: Store data at path
    FDB-->>FS: Confirm write
    FS-->>UI: Update UI
    
    U->>UI: Push data with auto-key
    UI->>FS: Push with timestamp
    FS->>FDB: Generate key & store
    FDB-->>FS: Return generated key
    FS-->>UI: Show updated data
    
    U->>UI: Delete path data
    UI->>FS: Delete request
    FS->>FDB: Remove data at path
    FDB-->>FS: Confirm deletion
    FS-->>UI: Update UI
```

## Feature Flags System Architecture

```mermaid
graph LR
    A[Application Start] --> B[Initialize Feature Flag Service]
    B --> C[Load Flags from Firebase]
    C --> D{Flag Exists?}
    
    D -->|Yes| E[Use Configured Value]
    D -->|No| F[Default: Enabled]
    
    E --> G[Feature Gate Check]
    F --> G
    G --> H{Is Enabled?}
    
    H -->|Yes| I[Execute Feature Code]
    H -->|No| J[Skip Feature]
    
    K[Admin Panel] --> L[Modify Feature Flags]
    L --> M[Update Firebase]
    M --> N[Real-time Sync]
    N --> O[All Clients Updated]

    style B fill:#e8f5e8
    style G fill:#fff3e0
    style K fill:#fce4ec
```

## Database Structure Diagram

```mermaid
graph TD
    A[Firebase Realtime Database] --> B[Root]
    
    B --> C[feature_flags/]
    C --> D[enabled/]
    C --> E[userGroups/]
    
    D --> F[feature1: true]
    D --> G[feature2: false]
    
    E --> H[hse/]
    E --> I[admin/]
    
    H --> J[feature1: true]
    H --> K[feature2: false]
    
    I --> L[feature1: true]
    I --> M[adminFeature: true]
    
    B --> N[Custom Data Paths]
    N --> O[users/]
    N --> P[messages/]
    N --> Q[test/]
    
    O --> R[user1: {name, email}]
    P --> S[auto-key: {message, timestamp}]
    Q --> T[name: "John Doe"]

    style A fill:#fff3e0
    style C fill:#e8f5e8
    style N fill:#e1f5fe
```

## Component Interaction Diagram

```mermaid
graph TD
    A[Main App] --> B[MainNavigation]
    
    B --> C[HomePage]
    B --> D[FeatureFlagsPage]
    B --> E[DemoPage]
    
    C --> F[FirebaseService]
    D --> G[FeatureFlagService]
    E --> H[FeatureGate]
    E --> I[FeatureWidget]
    
    F --> J[Firebase Realtime DB]
    G --> J
    H --> G
    I --> G
    
    J --> K[Real-time Listeners]
    J --> L[CRUD Operations]
    J --> M[Path Management]
    
    N[User Input] --> C
    N --> D
    N --> E
    
    O[Admin Actions] --> D
    O --> P[Feature Flag Updates]
    P --> J

    style A fill:#e1f5fe
    style F fill:#f3e5f5
    style G fill:#e8f5e8
    style J fill:#fff3e0
```

## Key Features Overview

### 🔥 Firebase Integration
- **Real-time Database**: Live data synchronization
- **Web Configuration**: Optimized for Flutter Web
- **Path-based Structure**: Flexible data organization

### 🎛️ Feature Flag System
- **User Group Support**: Different configurations per group
- **Default Behavior**: Enabled by default if not set
- **Real-time Updates**: Changes sync across all clients
- **Admin Interface**: Easy flag management

### 🖥️ User Interface
- **Responsive Design**: Works on all screen sizes
- **Three Main Sections**:
  1. **Database Demo**: Direct database operations
  2. **Feature Flags**: Flag management interface
  3. **Demo Page**: Feature flag demonstrations

### 🛠️ Core Operations
- **Write Data**: Store key-value pairs
- **Push Data**: Auto-generated keys with timestamps
- **Delete Data**: Remove data at specific paths
- **Real-time Listening**: Live data updates
- **Path Switching**: Dynamic database path changes

## Setup Flow

```mermaid
graph LR
    A[Create Firebase Project] --> B[Enable Realtime Database]
    B --> C[Configure Web App]
    C --> D[Copy Firebase Config]
    D --> E[Update firebase_config.dart]
    E --> F[Install Dependencies]
    F --> G[Run Flutter App]
    G --> H[Ready to Use!]

    style A fill:#fff3e0
    style H fill:#e8f5e8
```