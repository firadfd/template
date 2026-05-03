# 🚀 Flutter Ultimate Clean Architecture Template

A production-ready **Flutter Starter Template** meticulously structured using **Clean Architecture** patterns securely powered by **GetX**. This fully modular toolkit scales seamlessly, enabling lightning-fast UI rendering alongside highly optimized robust data workflows!

---

## 🏗 Directory Structure

This project completely isolates responsibilities across dedicated modules:

```text
lib/
├── app.dart                        # Core MaterialApp Initialization
├── main.dart                       # App entry point & Storage bootstrap
├── bindings/
│   └── app_binding.dart            # Global Dependency Injection
├── core/                           # Foundation Utilities shared globally
│   ├── config/                     # Environment & Flavor configurations (Dev, Staging, Prod)
│   ├── network/                    # Pure Network Layer (Decoupled from UI)
│   ├── storage/                    # GetStorage persistence interface
│   ├── theme/                      # Separated Dark/Light mode color schemes (AppColorScheme)
│   ├── localization/               # Externalized EN, AR, BN mapped translations
│   ├── utils/                      # Responsive Engine, Assets mapper, Validators
│   └── widgets/                    # Core generic UI components
├── features/                       # Modular business logic features
│   ├── splash/                     # Navigation & Auth logic hub
│   ├── onboarding/                 # First-time user experience
│   ├── auth/                       # Login & Registration modules
│   ├── main/                       # Bottom Navigation & Rail hub
│   └── home/                       # Feature-specific Repository, Binding, and Controller
└── routes/
    ├── app_pages.dart              # Route mappings with Feature Bindings
    └── app_routes.dart             # Static route URL constants
```

---

## 🚀 Initial Setup & Installation

1. **Clone & Enter the Repository**
   ```bash
   https://github.com/firadfd/template.git
   cd template
   ```

2. **Fetch Dependencies**
   ```bash
   flutter pub get
   ```

3. **Launch the App**
   ```bash
   flutter run
   ```

---

## 🛠 Rename & Rebrand (Customizing for your project)

After cloning, you'll want to change the App Name and Package Name to match your brand.

### 1. Manual Method
*   **App Name (Android)**: Update `android:label` in `android/app/src/main/AndroidManifest.xml`.
*   **App Name (iOS)**: Update `CFBundleName` string in `ios/Runner/Info.plist`.
*   **Package Name (Android)**: Update `applicationId` in `android/app/build.gradle`.
*   **Package Name (iOS)**: Update `PRODUCT_BUNDLE_IDENTIFIER` in `ios/Runner.xcodeproj/project.pbxproj`.

### 2. Automatic Method (Using Rename Package)
We recommend using the `rename` utility to handle all platform changes automatically.

**Step 1: Add the package to dev dependencies**
```bash
flutter pub add dev:rename
```

**Step 2: Run renaming commands**
```bash
# To change the Package Name (Bundle ID)
flutter pub run rename setBundleId --value "com.yourdomain.appname"

# To change the Application Name
flutter pub run rename setAppName --value "Your App Name"
```

---

## ✨ Premium Features Included

### 🏗 1. Feature-First Clean Architecture
- **Decoupled Layers**: UI → Controller → Repository → NetworkCaller.
- **Repository Pattern**: Data mapping (JSON to Object) happens in the Repository, keeping Controllers focused strictly on UI state.
- **Feature Bindings**: Controllers are lazy-loaded only when the user enters a route and disposed when they leave, optimizing memory usage.

### 📱 2. Global Responsive Engine
- **AppSizeClass**: Handles Mobile, Tablet, Desktop, and TV natively.
- **Context-Free Sizing**: Use `getHeight(100)`, `getSp(16)`, etc., anywhere in your logic or UI.

### 🌐 3. Multi-Environment Support (Flavors)
- **EnvConfig**: Built-in support for Development, Staging, and Production environments.
- **Dynamic BaseURLs**: Automatically switches API endpoints based on the active environment.

### 📡 4. Pure Network Engine
- **Decoupled UI**: Network errors are passed back to the caller, allowing the UI to decide how to display them (Snackbar, Dialog, or Error Screen).
- **Auto-Token Refresh**: Sophisticated JWT refresh logic with recursion guards built-in.
- **Connectivity Guard**: Automatic check for internet connection before every request.

### 🌍 5. Globalization & RTL
- **Multi-Language**: English, Arabic, and Bengali supported out-of-the-box.
- **RTL Support**: Arabic layout handles right-to-left directionality perfectly.

### 🖥️ 6. Adaptive UI (Mobile & Desktop)
- **Hybrid Navigation**: Automatically switches between `BottomNavigationBar` and `NavigationRail` based on screen width.
- **Platform Optimized**: Designed for touch, mouse, and keyboard interactions.

---

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

*Authored for rapid scalability and extreme code readability. Never struggle with state sprawl or messy API logic again!*
