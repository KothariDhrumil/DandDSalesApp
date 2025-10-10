# Deployment Guide

This guide explains how to use the CI/CD pipeline for building and deploying the D&D Sales App.

## 📦 Automated Builds

### Automatic APK Generation

Every push to the `main` or `master` branch automatically:

1. ✅ Runs Flutter tests
2. ✅ Analyzes code quality
3. ✅ Builds release APK
4. ✅ Builds App Bundle (AAB)
5. ✅ Uploads artifacts for download

### Downloading APK Files

After each successful build:

1. Go to the [Actions tab](../../actions) in GitHub
2. Click on the latest workflow run
3. Scroll down to the **Artifacts** section
4. Download either:
   - `android-apk-release` - Install directly on Android devices
   - `android-appbundle-release` - For Play Store deployment
   - `release-notes` - Build information

The artifacts are retained for 30 days.

## 🚀 Manual Deployments

### Deploy to Google Play Store

When you're ready to deploy to the Play Store:

1. Go to the [Actions tab](../../actions)
2. Select "Build and Deploy" workflow
3. Click "Run workflow"
4. Check "Deploy to Google Play Store"
5. Click "Run workflow"

**Prerequisites (Setup Required):**

Before deploying to Play Store, you need to:

1. **Create a Google Play Developer Account**
   - Visit [Google Play Console](https://play.google.com/console)
   - Pay the one-time registration fee ($25 USD)

2. **Create a Service Account**
   - Go to Play Console → Settings → API access
   - Create a new service account
   - Grant "Release Manager" permissions
   - Download the JSON key file

3. **Configure App Signing**
   - Set up app signing in Play Console
   - Generate upload key using:
     ```bash
     keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
     ```
   - Configure `android/key.properties`:
     ```properties
     storePassword=<password>
     keyPassword=<password>
     keyAlias=upload
     storeFile=<path-to-upload-keystore.jks>
     ```

4. **Add GitHub Secrets**
   - Go to repository Settings → Secrets and variables → Actions
   - Add the following secrets:
     - `PLAYSTORE_SERVICE_ACCOUNT_JSON` - Content of service account JSON
     - `KEYSTORE_FILE` - Base64 encoded keystore file
     - `KEYSTORE_PASSWORD` - Keystore password
     - `KEY_ALIAS` - Key alias
     - `KEY_PASSWORD` - Key password

5. **Uncomment Deployment Steps**
   - Edit `.github/workflows/build-and-deploy.yml`
   - Uncomment the Play Store deployment steps in the `deploy-to-playstore` job
   - Update the package name to match your app

### Deploy to Apple App Store

When you're ready to deploy to the App Store:

1. Go to the [Actions tab](../../actions)
2. Select "Build and Deploy" workflow
3. Click "Run workflow"
4. Check "Deploy to Apple App Store"
5. Click "Run workflow"

**Prerequisites (Setup Required):**

Before deploying to App Store, you need to:

1. **Enroll in Apple Developer Program**
   - Visit [Apple Developer](https://developer.apple.com/programs/)
   - Pay the annual fee ($99 USD)

2. **Configure iOS Project**
   - Ensure iOS project is initialized:
     ```bash
     flutter create --platforms=ios .
     ```
   - Update Bundle ID in Xcode
   - Configure signing & capabilities

3. **Create App Store Connect API Key**
   - Go to [App Store Connect](https://appstoreconnect.apple.com/)
   - Users and Access → Keys → App Store Connect API
   - Create a new key with "App Manager" role
   - Download the private key (.p8 file)

4. **Create Provisioning Profiles**
   - Go to Apple Developer Portal → Certificates, IDs & Profiles
   - Create App ID
   - Create Distribution Certificate
   - Create App Store provisioning profile

5. **Add GitHub Secrets**
   - Go to repository Settings → Secrets and variables → Actions
   - Add the following secrets:
     - `APPSTORE_API_KEY_ID` - API Key ID
     - `APPSTORE_API_ISSUER_ID` - Issuer ID
     - `APPSTORE_API_PRIVATE_KEY` - Content of .p8 file
     - `IOS_CERTIFICATE_P12` - Base64 encoded P12 certificate
     - `IOS_CERTIFICATE_PASSWORD` - Certificate password
     - `IOS_PROVISION_PROFILE` - Base64 encoded provisioning profile

6. **Uncomment Deployment Steps**
   - Edit `.github/workflows/build-and-deploy.yml`
   - Uncomment the iOS build and deployment steps in the `deploy-to-appstore` job

## 🔧 Workflow Configuration

### Build Triggers

The workflow runs on:
- Every push to `main` or `master` branches
- Manual trigger via "Run workflow" button

### Build Artifacts

Generated artifacts include:
- **android-apk-release** - Ready to install APK file
- **android-appbundle-release** - Ready for Play Store
- **release-notes** - Build metadata

### Build Environment

- **OS**: Ubuntu Latest (for Android)
- **Flutter**: 3.24.0 stable
- **Java**: OpenJDK 17
- **Cache**: Gradle and Flutter dependencies cached for faster builds

## 📱 Installing APK on Android Devices

### Via USB (ADB)

```bash
# Install the downloaded APK
adb install app-release.apk

# Or install with app replacement
adb install -r app-release.apk
```

### Direct Installation

1. Download the APK from GitHub Actions artifacts
2. Transfer to your Android device
3. Enable "Install from Unknown Sources" in device settings
4. Tap the APK file to install

### Via QR Code

1. Upload the APK to a file hosting service
2. Generate a QR code for the download link
3. Share the QR code with users
4. Users scan and download to install

## 🔍 Troubleshooting

### Build Fails

**Issue**: Build fails in CI/CD pipeline

**Solutions**:
- Check the workflow logs in Actions tab
- Ensure all dependencies in `pubspec.yaml` are compatible
- Verify code generation completes successfully
- Check for failing tests

### Tests Fail

**Issue**: Tests fail during CI/CD

**Solutions**:
- Run tests locally: `flutter test`
- Fix failing tests before pushing
- Check test logs in Actions tab

### Code Generation Issues

**Issue**: Build runner fails

**Solutions**:
- Ensure all model annotations are correct
- Check for conflicting generated files
- Verify build_runner version compatibility

### Artifact Not Found

**Issue**: APK artifact not available for download

**Solutions**:
- Ensure the build completed successfully
- Check if artifacts expired (30 days retention)
- Verify the artifact upload step succeeded

### Signing Issues (Play Store)

**Issue**: App signing fails during deployment

**Solutions**:
- Verify keystore file is correctly encoded in secrets
- Check keystore password is correct
- Ensure key alias matches the configuration
- Verify service account has proper permissions

### iOS Build Issues (App Store)

**Issue**: iOS build or deployment fails

**Solutions**:
- Ensure provisioning profiles are valid and not expired
- Check certificate is valid
- Verify Bundle ID matches App Store Connect
- Ensure API key has proper permissions

## 📊 Build Status

Add this badge to your README to show build status:

```markdown
![Build Status](https://github.com/KothariDhrumil/DandDSalesApp/actions/workflows/build-and-deploy.yml/badge.svg)
```

## 🔐 Security Best Practices

1. **Never commit secrets** to the repository
2. **Use GitHub Secrets** for all sensitive data
3. **Rotate keys regularly** (every 90 days recommended)
4. **Limit secret access** to only necessary workflows
5. **Use separate keys** for different environments (dev/staging/prod)
6. **Enable 2FA** on all service accounts

## 📝 Release Process

### Creating a Release

1. Update version in `pubspec.yaml`:
   ```yaml
   version: 1.0.1+2  # version+build number
   ```

2. Commit and push changes
3. Wait for automatic build to complete
4. Download artifacts from Actions
5. Test the APK thoroughly
6. When ready, use manual dispatch to deploy to stores

### Version Numbering

Follow semantic versioning:
- `MAJOR.MINOR.PATCH+BUILD`
- Example: `1.2.3+45`
  - `1` - Major version
  - `2` - Minor version
  - `3` - Patch version
  - `45` - Build number

## 🎯 Next Steps

1. ✅ CI/CD pipeline is ready for APK builds
2. ⏳ Set up Play Store account and configure deployment
3. ⏳ Set up App Store account and configure deployment
4. ⏳ Add automated version bumping
5. ⏳ Set up beta testing tracks
6. ⏳ Configure automated release notes generation
7. ⏳ Add screenshot testing
8. ⏳ Set up performance monitoring

## 🆘 Support

If you need help with deployment:

1. Check the [GitHub Actions documentation](https://docs.github.com/en/actions)
2. Review the [Flutter deployment guide](https://docs.flutter.dev/deployment)
3. Open an issue in the repository
4. Contact the development team

---

**Last Updated**: October 2025  
**Pipeline Version**: 1.0.0
