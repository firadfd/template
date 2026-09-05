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
│   ├── auth/                       # Login flow: the reference vertical slice
│   ├── main/                       # Bottom Navigation & Rail hub
│   └── profile/                    # Settings, language, theme, logout
└── routes/
    ├── app_pages.dart              # Route mappings with Feature Bindings
    └── app_routes.dart             # Static route URL constants

tool/
└── pre-commit.sh                   # format -> analyze -> test gate
```

The `auth` feature is the reference implementation. It is a complete vertical
slice — binding -> controller -> repository -> typed model -> view — and it is
covered by tests. Copy its shape when you add a feature.

The tabs behind the bottom navigation are `PlaceholderView`s. Replace them in
`lib/features/main/controller/main_controller.dart` with your own screens.

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
   flutter run --dart-define=APP_ENV=dev
   ```

   The environment is chosen at compile time, so a release build cannot
   accidentally ship pointing at a dev server. Point a build anywhere with
   `--dart-define=API_BASE_URL=https://...`. Set your real hosts in
   `lib/core/config/env_config.dart`.

4. **No backend yet? Run with mock auth**
   ```bash
   flutter run --dart-define=MOCK_AUTH=true
   ```

   The login screen calls a real API. Until you have one, this define makes
   `AuthRepository` issue fake tokens locally, so **any** non-empty email and
   password signs you in and lands you on the main screen. A banner on the
   login screen shows when it is active.

   It is ignored when `APP_ENV=prod`, so it cannot ship in a release build.

   To get back to the login screen afterwards, use **Logout** on the Profile
   tab — the token is persisted, so the splash screen will otherwise send you
   straight to main on the next launch.

5. **Install the pre-commit hook** (recommended)
   ```bash
   ./tool/pre-commit.sh --install
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

### 🌐 3. Multi-Environment Support
- **EnvConfig**: Development, Staging and Production, selected at compile time
  via `--dart-define=APP_ENV=`, with an optional `API_BASE_URL` override.
- Note: these are compile-time environments, not Flutter/Gradle *flavors*. If
  you need separate application IDs or icons per environment, add real flavors
  in `android/app/build.gradle` and an Xcode scheme.

### 📡 4. Pure Network Engine
- **Decoupled UI**: Network errors are passed back to the caller, allowing the UI to decide how to display them (Snackbar, Dialog, or Error Screen).
- **Auto-Token Refresh**: JWT refresh with a recursion guard and *single-flight*
  de-duplication — concurrent 401s share one refresh, so a backend that rotates
  refresh tokens will not log the user out.
- **Injectable**: `NetworkCaller` takes an `http.Client` and a connectivity
  check, so it is unit-testable without sockets or platform plugins.
- **Connectivity Guard**: Automatic check for internet connection before every request.

### 🌍 5. Globalization & RTL
- **Multi-Language**: English, Arabic, and Bengali supported out-of-the-box.
- **RTL Support**: Arabic layout handles right-to-left directionality perfectly.

### 🖥️ 6. Adaptive UI (Mobile & Desktop)
- **Hybrid Navigation**: Automatically switches between `BottomNavigationBar` and `NavigationRail` based on screen width.
- **Platform Optimized**: Designed for touch, mouse, and keyboard interactions.

### 🧹 7. Linting & Formatting
The Dart equivalent of an ESLint + Prettier setup. There is no ESLint or
Prettier here — those are JavaScript tools and do not run on Dart.

| Concern | Tool | Config |
| --- | --- | --- |
| Linting | `dart analyze` | `analysis_options.yaml` (`linter.rules`) |
| Type strictness | analyzer | `analysis_options.yaml` (`strict-casts`, `strict-raw-types`) |
| Formatting | `dart format` | `analysis_options.yaml` (`formatter.page_width: 80`) |
| Editor | Dart-Code | `.vscode/settings.json`, `.editorconfig` |
| Pre-commit | git hook | `tool/pre-commit.sh` |
| CI | GitHub Actions | `.github/workflows/flutter_ci.yml` |

```bash
dart format .                                   # apply formatting
dart fix --apply                                # auto-fix lint violations
flutter analyze --fatal-infos --fatal-warnings  # what CI runs
flutter test                                    # what CI runs
./tool/pre-commit.sh                            # all of the above
```

`strict-casts` is on, so unchecked `dynamic` from JSON will not compile. Parse
at the boundary — see `lib/features/auth/model/auth_tokens.dart` for the
pattern.

**Code generation** is not preinstalled, because nothing in the template needs
it. When you add your first generated model, pull it in with one command:

```bash
flutter pub add json_annotation dev:build_runner dev:json_serializable
# or, for freezed unions/copyWith:
flutter pub add freezed_annotation dev:build_runner dev:freezed
```

`analysis_options.yaml` already excludes `*.g.dart` and `*.freezed.dart`, so
generated files stay out of the linter and the formatter.

### ✅ 8. Tested & Gated
`flutter test` covers the network layer (single-flight refresh, connectivity
short-circuit, typed error mapping), the auth repository, and the login screen.
CI runs format, analyze and test as a `verify` job that must pass **before**
the APK build or any release runs.

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
