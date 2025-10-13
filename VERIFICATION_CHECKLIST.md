# Build Verification Checklist

Use this checklist to verify that the project builds correctly after the updates.

## Prerequisites Verification

- [ ] Flutter SDK installed (3.0.0+)
  ```bash
  flutter --version
  ```

- [ ] Java 17+ installed
  ```bash
  java -version
  ```

- [ ] Android Studio installed with SDK 34
  - Open Android Studio → SDK Manager
  - Verify Android 14.0 (API 34) is installed

- [ ] Xcode installed (macOS only, for iOS)
  ```bash
  xcode-select --version
  ```

- [ ] Flutter doctor passes
  ```bash
  flutter doctor -v
  ```

## Project Structure Verification

- [ ] `android/` directory exists with:
  - [ ] `build.gradle` (project-level)
  - [ ] `settings.gradle`
  - [ ] `gradle.properties`
  - [ ] `app/build.gradle` (app-level)
  - [ ] `app/src/main/AndroidManifest.xml`
  - [ ] `app/src/main/kotlin/com/dandd/dandd_sales_app/MainActivity.kt`
  - [ ] `gradle/wrapper/gradle-wrapper.properties`

- [ ] `ios/` directory exists with:
  - [ ] `Podfile`
  - [ ] `Runner/Info.plist`
  - [ ] `Runner/AppDelegate.swift`

- [ ] `web/` directory exists with:
  - [ ] `index.html`
  - [ ] `manifest.json`

- [ ] `assets/` directory exists with:
  - [ ] `images/` subdirectory
  - [ ] `icons/` subdirectory
  - [ ] `fonts/` subdirectory

- [ ] `lib/` directory contains your Dart code

- [ ] Root directory contains:
  - [ ] `pubspec.yaml`
  - [ ] `.metadata`
  - [ ] `.gitignore`

## Dependency Installation

- [ ] Dependencies install successfully
  ```bash
  flutter pub get
  ```
  Expected: "Got dependencies!" message

- [ ] No dependency conflicts reported

- [ ] Code generation works (if needed)
  ```bash
  flutter pub run build_runner build --delete-conflicting-outputs
  ```

## Android Build Verification

- [ ] Gradle sync succeeds
  ```bash
  cd android
  ./gradlew --version
  ```
  Expected: Gradle 8.5, Kotlin 1.9.22

- [ ] Android project structure recognized
  ```bash
  cd android
  ./gradlew tasks
  cd ..
  ```

- [ ] Debug APK builds
  ```bash
  flutter build apk --debug
  ```
  Expected: APK at `build/app/outputs/flutter-apk/app-debug.apk`

- [ ] Release APK builds
  ```bash
  flutter build apk --release
  ```
  Expected: APK at `build/app/outputs/flutter-apk/app-release.apk`

- [ ] App bundle builds
  ```bash
  flutter build appbundle --release
  ```
  Expected: AAB at `build/app/outputs/bundle/release/app-release.aab`

## iOS Build Verification (macOS only)

- [ ] CocoaPods installs
  ```bash
  cd ios
  pod install
  cd ..
  ```

- [ ] Debug build succeeds
  ```bash
  flutter build ios --debug --no-codesign
  ```

- [ ] Release build succeeds
  ```bash
  flutter build ios --release --no-codesign
  ```

## Web Build Verification

- [ ] Web build succeeds
  ```bash
  flutter build web --release
  ```
  Expected: Build at `build/web/`

## Runtime Verification

- [ ] App runs in debug mode on Android emulator
  ```bash
  flutter run -d <android-device-id>
  ```

- [ ] App runs in debug mode on iOS simulator (macOS)
  ```bash
  flutter run -d <ios-device-id>
  ```

- [ ] App runs in Chrome for web
  ```bash
  flutter run -d chrome
  ```

- [ ] Hot reload works
  - Make a change to a Dart file
  - Press 'r' in terminal or save in IDE
  - Change appears in running app

- [ ] No runtime errors in debug console

## Code Quality Verification

- [ ] No analysis errors
  ```bash
  flutter analyze
  ```
  Expected: "No issues found!"

- [ ] Tests pass (if tests exist)
  ```bash
  flutter test
  ```

## Configuration Verification

- [ ] Android configuration correct:
  - [ ] compileSdk = 34
  - [ ] targetSdk = 34
  - [ ] minSdk = 21
  - [ ] Gradle version = 8.5
  - [ ] AGP version = 8.3.0
  - [ ] Kotlin version = 1.9.22
  - [ ] Java target = 17

- [ ] iOS configuration correct:
  - [ ] Minimum iOS version = 12.0
  - [ ] Podfile uses modern syntax

- [ ] pubspec.yaml:
  - [ ] SDK constraint is `>=3.0.0 <4.0.0`
  - [ ] All dependencies listed
  - [ ] Assets paths correct

## Documentation Verification

- [ ] BUILD_SETUP.md exists and is accurate
- [ ] MIGRATION_GUIDE.md exists
- [ ] QUICK_START.md exists
- [ ] README.md updated with latest information
- [ ] SETUP_GUIDE.md updated

## Git Verification

- [ ] All new files are tracked
  ```bash
  git status
  ```

- [ ] Appropriate files are in .gitignore
  - [ ] `android/.gradle`
  - [ ] `android/local.properties`
  - [ ] `ios/Pods`
  - [ ] `build/`
  - [ ] `.dart_tool/`

- [ ] No sensitive information committed
  - [ ] No API keys
  - [ ] No passwords
  - [ ] No signing keystores

## Optional Enhancements (Future Tasks)

- [ ] Add app icons for all platforms
- [ ] Add splash screens
- [ ] Add Roboto fonts to assets/fonts/
- [ ] Configure release signing for Android
- [ ] Configure provisioning for iOS
- [ ] Set up CI/CD pipeline
- [ ] Add more comprehensive tests

## Troubleshooting

If any check fails, refer to:

1. **BUILD_SETUP.md** - Detailed build instructions
2. **MIGRATION_GUIDE.md** - Common issues and solutions
3. **SETUP_GUIDE.md** - Setup troubleshooting
4. **Flutter Doctor** - Run `flutter doctor -v` for diagnostics

## Final Confirmation

- [ ] ✅ Project builds successfully on Android
- [ ] ✅ Project builds successfully on iOS (if on macOS)
- [ ] ✅ Project builds successfully on Web
- [ ] ✅ No build errors or warnings
- [ ] ✅ Documentation is complete
- [ ] ✅ Ready for development

---

**Checklist Version**: 1.0  
**Last Updated**: October 2025

## Notes

Use this space to note any issues or customizations:

```
[Add your notes here]
```
