# 🚀 Flutter Ultimate Clean Architecture Template

A production-ready **Flutter Starter Template** meticulously structured using **Clean Architecture** patterns securely powered natively by **GetX**. This fully modular toolkit scales seamlessly, enabling lightning-fast UI rendering alongside highly optimized robust data workflows!

---

## 🏗 Directory Structure

This project completely isolates responsibilities natively across dedicated modules:

```text
lib/
├── app.dart                        # Core MaterialApp Initialization
├── main.dart                       # App entry point natively bound to initialization
├── bindings/
│   └── app_binding.dart            # Centralized GetX Dependency Injection (Singleton Pattern)
├── core/                           # Foundation Utilities shared globally
│   ├── network/                    # API Endpoints and Custom NetworkCaller Engine
│   ├── storage/                    # GetStorage persistence interface
│   ├── theme/                      # Separated Dark/Light mode color schemes (AppColorScheme)
│   ├── localization/               # Externalized EN, AR, BN mapped translation dictionaries
│   ├── utils/                      # Settings global utils, Assets structural mapper
│   │   └── app_size_class.dart     # Global Responsive Engine (Mobile, Tablet, Desktop, TV)
│   └── widgets/                    # Core generic UI components (Buttons, Skeleton items, Svgs)
├── features/                       # Segmented modular apps exactly implementing clean workflows
│   ├── splash/                     # Navigation & Auth logic hub
│   ├── onboarding/                 # First-time user experience
│   ├── auth/                       # Login & Registration modules
│   ├── main/                       # Bottom Navigation hub (Home & Profile)
│   └── home/                       # Core content module (API driven)
└── routes/
    ├── app_pages.dart              # Global Navigation mappings statically
    └── app_routes.dart             # Distinct string-based Route mapping URLs
```

---

## 🚀 Initial Setup & Installation

To initialize this cleanly built template precisely from scratch anywhere:

1. **Clone & Enter the Repository**
   ```bash
   https://github.com/firadfd/template.git
   cd template
   ```

2. **Fetch Dependencies**
   Run the following to completely pull down all explicitly bounded GetX, Networking, and Assets packages natively:
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

## ✨ Outstanding Features Enabled Out Of The Box

### 📱 1. Global Responsive Engine (Context-Free)
The project includes a built-in `AppSizeClass` that handles all screen sizes natively (Mobile, Tablet, Desktop, and TV).
- **Global Calls**: Use `getHeight(100)`, `getWidth(50)`, `getSp(16)`, `getRadius(12)` directly anywhere.
- **Convenience**: No more `context` boilerplate for sizing!
- **Adaptive**: Automatically recalculates on orientation change or window resizing.

### 📡 2. Robust API NetworkCaller 
Includes an advanced, globally injected `NetworkCaller`.
- Automatically parses success and error JSON gracefully without UI crashing.
- Includes JWT **Auto-Refreshing Token** mechanisms built inside `_getHeaders()` and `_sendRequest()`.
- Supports transparent background fetches. Easily disables UI-blocking `EasyLoading` overlays by setting `showLoading: false` inside requests!

### ⚙️ 3. Universal State & Dependency Injection (GetX)
No messy `StatefulWidget` sprawl or un-traceable components:
- Centralized `AppBinding` natively handles injecting global Singletons (`StorageService`, `NetworkCaller`, etc.) the exact moment the app mounts.
- Controllers bind to data gracefully allowing strictly optimal single-page modular logic! All Views are strictly `StatelessWidget`.

### 🌐 4. Multi-Language (Localization & RTL)
Instantly globalize natively! 
- Supports **English, Arabic (Right-to-Left Layout perfectly supported), and Bengali**.
- Translations mapped to individually externalized files cleanly residing inside `lib/core/localization/langs/`.

---

*Authored optimally for rapid scalability and extreme code readability. Never struggle to find where API calls or UI states originate again!*
