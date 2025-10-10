# CI/CD Pipeline Flow

## 📊 Build Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                      PUSH TO MAIN/MASTER                        │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                   GitHub Actions Triggered                      │
│                   Workflow: build-and-deploy.yml                │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    JOB: build-android                           │
├─────────────────────────────────────────────────────────────────┤
│  1. ✅ Checkout Code                                            │
│  2. ✅ Setup Java 17                                            │
│  3. ✅ Setup Flutter 3.24.0                                     │
│  4. ✅ Install Dependencies (flutter pub get)                  │
│  5. ✅ Generate Code (build_runner)                            │
│  6. ✅ Analyze Code (flutter analyze)                          │
│  7. ✅ Run Tests (flutter test)                                │
│  8. ✅ Build APK (flutter build apk --release)                 │
│  9. ✅ Build App Bundle (flutter build appbundle --release)    │
│ 10. ✅ Create Release Notes                                     │
│ 11. ✅ Upload APK Artifact                                      │
│ 12. ✅ Upload App Bundle Artifact                               │
│ 13. ✅ Upload Release Notes                                     │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                      ARTIFACTS AVAILABLE                        │
├─────────────────────────────────────────────────────────────────┤
│  📦 android-apk-release (app-release.apk)                      │
│  📦 android-appbundle-release (app-release.aab)                │
│  📦 release-notes (release-notes.txt)                          │
│                                                                 │
│  🕒 Retention: 30 days                                          │
└─────────────────────────────────────────────────────────────────┘
```

## 🎯 Manual Deployment Flow

### Play Store Deployment

```
┌─────────────────────────────────────────────────────────────────┐
│     User: Actions → Run Workflow → Deploy to Play Store        │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│              JOB: deploy-to-playstore (conditional)             │
├─────────────────────────────────────────────────────────────────┤
│  Requires: github.event.inputs.deploy_to_playstore == 'true'   │
│  Depends on: build-android job                                  │
├─────────────────────────────────────────────────────────────────┤
│  1. ✅ Checkout Code                                            │
│  2. ✅ Download App Bundle Artifact                             │
│  3. ⏳ Setup Service Account (needs configuration)              │
│  4. ⏳ Deploy to Play Store (commented out)                     │
│                                                                 │
│  Required Secrets:                                              │
│  - PLAYSTORE_SERVICE_ACCOUNT_JSON                              │
│  - KEYSTORE_FILE                                                │
│  - KEYSTORE_PASSWORD                                            │
│  - KEY_ALIAS                                                    │
│  - KEY_PASSWORD                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### App Store Deployment

```
┌─────────────────────────────────────────────────────────────────┐
│      User: Actions → Run Workflow → Deploy to App Store        │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│               JOB: deploy-to-appstore (conditional)             │
├─────────────────────────────────────────────────────────────────┤
│  Requires: github.event.inputs.deploy_to_appstore == 'true'    │
│  Runs on: macos-latest                                          │
├─────────────────────────────────────────────────────────────────┤
│  1. ✅ Checkout Code                                            │
│  2. ✅ Setup Flutter                                            │
│  3. ✅ Install Dependencies                                     │
│  4. ✅ Generate Code                                            │
│  5. ⏳ Setup iOS Environment (needs configuration)              │
│  6. ⏳ Build iOS IPA (commented out)                            │
│  7. ⏳ Deploy to TestFlight (commented out)                     │
│                                                                 │
│  Required Secrets:                                              │
│  - APPSTORE_API_KEY_ID                                          │
│  - APPSTORE_API_ISSUER_ID                                       │
│  - APPSTORE_API_PRIVATE_KEY                                     │
│  - IOS_CERTIFICATE_P12                                          │
│  - IOS_CERTIFICATE_PASSWORD                                     │
│  - IOS_PROVISION_PROFILE                                        │
└─────────────────────────────────────────────────────────────────┘
```

## 🔄 Workflow Triggers

### Automatic Triggers
```
Push Event
    ↓
main/master branch?
    ↓ YES
Run build-android job
    ↓
Generate & Upload Artifacts
```

### Manual Triggers
```
User clicks "Run Workflow"
    ↓
Select Options:
  [ ] Deploy to Play Store
  [ ] Deploy to App Store
    ↓
Click "Run Workflow"
    ↓
Run selected jobs
```

## 📦 Artifact Flow

```
┌──────────────┐
│ Build APK    │
│   (Job)      │
└──────┬───────┘
       │
       ├─────────────┐
       │             │
       ▼             ▼
┌──────────┐   ┌──────────┐
│   APK    │   │   AAB    │
│ Artifact │   │ Artifact │
└─────┬────┘   └────┬─────┘
      │             │
      └──────┬──────┘
             │
             ▼
    ┌────────────────┐
    │  GitHub        │
    │  Artifacts     │
    │  Storage       │
    │  (30 days)     │
    └────────┬───────┘
             │
      ┌──────┴───────┐
      │              │
      ▼              ▼
┌──────────┐   ┌──────────┐
│   User   │   │  Deploy  │
│ Download │   │   Job    │
└──────────┘   └──────────┘
```

## 🎯 User Interaction Points

### For End Users
```
GitHub Actions
    ↓
[View Workflow Runs]
    ↓
[Select Latest Run]
    ↓
[Scroll to Artifacts]
    ↓
[Click android-apk-release]
    ↓
[Download APK]
    ↓
[Install on Device]
```

### For Developers
```
Code Changes
    ↓
[git commit]
    ↓
[git push origin main]
    ↓
[Wait for Build]
    ↓
[Check Status Badge]
    ↓
[Download & Test APK]
```

### For Release Managers
```
[Go to Actions]
    ↓
[Click "Build and Deploy"]
    ↓
[Click "Run workflow"]
    ↓
[Select Branch]
    ↓
[Check Deployment Options]
    ↓
[Run Workflow]
    ↓
[Monitor Progress]
    ↓
[Verify Deployment]
```

## ⚙️ Configuration States

### Current State (Active)
```
✅ Automatic APK builds
✅ Code quality checks
✅ Test execution
✅ Artifact uploads
✅ 30-day retention
```

### Ready to Activate (Needs Setup)
```
⏳ Play Store deployment
⏳ App Store deployment
⏳ Automated signing
⏳ Release notes generation
⏳ Changelog automation
```

### Future Enhancements
```
💡 Beta testing tracks
💡 Staged rollouts
💡 A/B testing support
💡 Performance monitoring
💡 Crash reporting integration
💡 Automated screenshot testing
```

## 🔐 Security Flow

```
Code Push
    ↓
GitHub Actions
    ↓
Secrets Manager
    ↓ (Encrypted)
Build Environment
    ↓
Signing Process
    ↓
Signed Artifacts
    ↓
Secure Storage
    ↓
Distribution
```

## 📊 Monitoring & Feedback

```
Build Starts
    ↓
Status Badge Updates
    ↓
Build Logs Available
    ↓
Email Notifications (if configured)
    ↓
Build Completes
    ↓
Artifacts Ready
    ↓
Status Badge Shows Result
```

## 🎨 Legend

- ✅ Active/Working
- ⏳ Pending Configuration
- 💡 Future Enhancement
- 📦 Artifact
- 🔒 Requires Secrets
- 🎯 User Action
- 🔄 Automatic Process

---

**Note**: This flow represents the current implementation. As you configure secrets and enable deployment jobs, additional steps will become active.

See [DEPLOYMENT_GUIDE.md](../DEPLOYMENT_GUIDE.md) for setup instructions.
