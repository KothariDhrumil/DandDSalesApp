# Build Setup - Latest Versions

This document describes the updated build configuration with the latest versions of all tools and dependencies.

## What's Been Updated

### Android Configuration

The project now uses the latest Android build tools and configuration:

- **Android Gradle Plugin**: 8.3.0 (latest stable)
- **Gradle**: 8.5 (latest stable)
- **Kotlin**: 1.9.22 (latest stable)
- **Compile SDK**: 34 (Android 14)
- **Target SDK**: 34 (Android 14)
- **Min SDK**: 21 (Android 5.0)
- **Java/Kotlin Target**: 17
- **NDK**: 25.1.8937393

### iOS Configuration

- **Minimum iOS Version**: 12.0
- **Podfile**: Updated with latest Flutter integration

### Build Features

- Uses latest Flutter Gradle Plugin integration
- AndroidX enabled
- Jetifier enabled
- Build config features properly configured
- Non-transitive R class disabled for compatibility
- Proper memory settings for Gradle builds (4GB heap)

## Project Structure

```
DandDSalesApp/
├── android/                     # Android platform code
│   ├── app/
│   │   ├── src/main/
│   │   │   ├── kotlin/         # Kotlin source code
│   │   │   ├── res/            # Android resources
│   │   │   └── AndroidManifest.xml
│   │   └── build.gradle        # App-level Gradle config
│   ├── gradle/wrapper/         # Gradle wrapper
│   ├── build.gradle            # Project-level Gradle config
│   ├── gradle.properties       # Gradle properties
│   └── settings.gradle         # Gradle settings
├── ios/                         # iOS platform code
│   ├── Runner/
│   │   ├── AppDelegate.swift   # iOS app delegate
│   │   └── Info.plist          # iOS configuration
│   └── Podfile                 # CocoaPods dependencies
├── web/                         # Web platform code
│   ├── index.html              # Web entry point
│   └── manifest.json           # PWA manifest
├── lib/                         # Dart source code
├── assets/                      # Application assets
│   ├── images/
│   ├── icons/
│   └── fonts/
├── test/                        # Tests
└── pubspec.yaml                # Flutter dependencies

```

## How to Build

### Prerequisites

1. Install Flutter SDK (3.0.0 or higher recommended)
   ```bash
   # Follow instructions at:
   https://docs.flutter.dev/get-started/install
   ```

2. Verify installation:
   ```bash
   flutter doctor
   ```

### Build Steps

1. **Get dependencies**:
   ```bash
   flutter pub get
   ```

2. **Generate code** (if needed):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Build for Android**:
   ```bash
   # Debug APK
   flutter build apk --debug
   
   # Release APK
   flutter build apk --release
   
   # App Bundle for Play Store
   flutter build appbundle --release
   ```

4. **Build for iOS** (macOS only):
   ```bash
   # Debug
   flutter build ios --debug
   
   # Release
   flutter build ios --release
   ```

5. **Build for Web**:
   ```bash
   flutter build web --release
   ```

6. **Run the app**:
   ```bash
   # On connected device or emulator
   flutter run
   
   # On specific device
   flutter devices
   flutter run -d <device-id>
   ```

## Troubleshooting

### Gradle Issues

If you encounter Gradle build failures:

1. Clean the build:
   ```bash
   flutter clean
   cd android
   ./gradlew clean
   cd ..
   flutter pub get
   ```

2. Invalidate caches:
   ```bash
   cd android
   ./gradlew --stop
   rm -rf .gradle
   cd ..
   ```

### iOS Issues

If you encounter iOS build issues:

1. Clean the build:
   ```bash
   flutter clean
   cd ios
   rm -rf Pods Podfile.lock
   pod install
   cd ..
   ```

2. Update CocoaPods:
   ```bash
   sudo gem install cocoapods
   pod repo update
   ```

### Common Errors

#### "Gradle version too old"
- **Solution**: The project now uses Gradle 8.5. Delete the `android/.gradle` directory and rebuild.

#### "SDK version mismatch"
- **Solution**: Ensure Android SDK 34 is installed via Android Studio SDK Manager.

#### "Kotlin version conflict"
- **Solution**: The project uses Kotlin 1.9.22. This should resolve automatically.

## What Changed from Previous Version

1. **Gradle**: Upgraded from outdated version to 8.5
2. **Android Gradle Plugin**: Upgraded to 8.3.0
3. **Kotlin**: Upgraded to 1.9.22
4. **Android SDK**: Updated to target SDK 34 (Android 14)
5. **Build Configuration**: Modernized with latest Flutter Gradle plugin
6. **Min SDK**: Remains at 21 for broad compatibility
7. **Java Target**: Updated to Java 17 (required by AGP 8.3.0)

## Notes

- The fonts in pubspec.yaml are temporarily commented out. Add Roboto fonts to `assets/fonts/` or use system fonts.
- App icons need to be added to appropriate directories for each platform.
- The project is now compatible with the latest Flutter SDK versions.
- All build tools are using their latest stable versions as of October 2025.

## Next Steps

1. Add application icons for Android, iOS, and Web
2. Add Roboto fonts or update to use different fonts
3. Configure signing for release builds (Android keystore, iOS provisioning)
4. Test on actual devices
5. Set up CI/CD pipeline with these new configurations

## References

- [Flutter Documentation](https://docs.flutter.dev/)
- [Android Gradle Plugin Release Notes](https://developer.android.com/studio/releases/gradle-plugin)
- [Gradle Release Notes](https://gradle.org/releases/)
- [Kotlin Release Notes](https://kotlinlang.org/docs/releases.html)
