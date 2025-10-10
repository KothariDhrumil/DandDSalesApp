# GitHub Actions Workflows

This directory contains automated workflows for the D&D Sales App.

## Available Workflows

### 1. Build and Deploy (`build-and-deploy.yml`)

Main CI/CD workflow that handles building and deploying the application.

#### Triggers
- **Automatic**: Runs on every push to `main` or `master` branches
- **Manual**: Can be triggered manually via GitHub Actions UI

#### Jobs

##### `build-android`
Builds the Android application and uploads artifacts.

**Steps:**
1. Checkout code
2. Setup Java 17
3. Setup Flutter 3.24.0
4. Install dependencies
5. Generate code
6. Analyze code
7. Run tests
8. Build release APK
9. Build release App Bundle
10. Upload artifacts

**Outputs:**
- `android-apk-release` - Installable APK file
- `android-appbundle-release` - App Bundle for Play Store
- `release-notes` - Build information

##### `deploy-to-playstore` (Optional)
Deploys the app to Google Play Store when manually triggered.

**Prerequisites:**
- Service account JSON key
- App signing configuration
- GitHub secrets configured

**Trigger:** Manual workflow dispatch with "Deploy to Google Play Store" checked

##### `deploy-to-appstore` (Optional)
Deploys the app to Apple App Store when manually triggered.

**Prerequisites:**
- Apple Developer account
- Provisioning profiles
- Code signing certificates
- GitHub secrets configured

**Trigger:** Manual workflow dispatch with "Deploy to Apple App Store" checked

## Running Workflows

### Automatic Builds
Simply push your code to `main` or `master` branch:
```bash
git push origin main
```

The workflow will automatically start and build the APK.

### Manual Deployment

1. Navigate to repository → Actions → "Build and Deploy"
2. Click "Run workflow"
3. Select branch
4. Check deployment options:
   - ☐ Deploy to Google Play Store
   - ☐ Deploy to Apple App Store
5. Click "Run workflow"

## Downloading Build Artifacts

1. Go to repository → Actions
2. Click on a completed workflow run
3. Scroll to "Artifacts" section
4. Download desired artifacts:
   - **android-apk-release** - For direct installation
   - **android-appbundle-release** - For Play Store
   - **release-notes** - Build metadata

## Required Secrets

### For Play Store Deployment
- `PLAYSTORE_SERVICE_ACCOUNT_JSON` - Service account credentials
- `KEYSTORE_FILE` - Android signing keystore (base64 encoded)
- `KEYSTORE_PASSWORD` - Keystore password
- `KEY_ALIAS` - Key alias name
- `KEY_PASSWORD` - Key password

### For App Store Deployment
- `APPSTORE_API_KEY_ID` - App Store Connect API key ID
- `APPSTORE_API_ISSUER_ID` - API issuer ID
- `APPSTORE_API_PRIVATE_KEY` - Private key content
- `IOS_CERTIFICATE_P12` - iOS certificate (base64 encoded)
- `IOS_CERTIFICATE_PASSWORD` - Certificate password
- `IOS_PROVISION_PROFILE` - Provisioning profile (base64 encoded)

## Workflow Customization

### Change Flutter Version
Edit the `flutter-version` in the workflow:
```yaml
- name: Setup Flutter
  uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.24.0'  # Change this
    channel: 'stable'
```

### Change Java Version
Edit the `java-version` in the workflow:
```yaml
- name: Setup Java
  uses: actions/setup-java@v4
  with:
    distribution: 'zulu'
    java-version: '17'  # Change this
```

### Change Artifact Retention
Edit the `retention-days` in artifact upload steps:
```yaml
- name: Upload APK artifact
  uses: actions/upload-artifact@v4
  with:
    name: android-apk-release
    path: build/app/outputs/flutter-apk/app-release.apk
    retention-days: 30  # Change this
```

### Add Build Variants
To build debug or profile variants, add additional steps:
```yaml
- name: Build Android APK (Debug)
  run: flutter build apk --debug

- name: Build Android APK (Profile)
  run: flutter build apk --profile
```

## Troubleshooting

### Build Fails
- Check workflow logs for errors
- Ensure all dependencies are up to date
- Verify Flutter version compatibility
- Check for test failures

### Artifacts Not Generated
- Verify build completed successfully
- Check file paths in upload steps
- Ensure build outputs exist

### Deployment Fails
- Verify all secrets are correctly set
- Check service account permissions
- Ensure certificates are valid
- Review store-specific requirements

## Best Practices

1. **Test Locally First**: Always test builds locally before pushing
2. **Keep Secrets Secure**: Never log or expose secrets
3. **Monitor Builds**: Check build status regularly
4. **Update Dependencies**: Keep workflow actions updated
5. **Document Changes**: Update this README when modifying workflows

## Support

For issues or questions:
- Review workflow logs
- Check [DEPLOYMENT_GUIDE.md](../../DEPLOYMENT_GUIDE.md)
- Open an issue in the repository
- Contact the development team

---

**Last Updated**: October 2025
