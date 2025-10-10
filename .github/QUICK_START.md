# CI/CD Quick Start Guide

## 🚀 Getting Your APK

Every time you push code to `main` or `master`, an APK is automatically built!

### Download Steps:

1. **Go to Actions Tab**
   - Visit: https://github.com/KothariDhrumil/DandDSalesApp/actions

2. **Select Latest Workflow Run**
   - Click on the most recent "Build and Deploy" workflow

3. **Download APK**
   - Scroll to the bottom "Artifacts" section
   - Click on `android-apk-release` to download

4. **Install on Android Device**
   - Transfer APK to your phone
   - Enable "Install from Unknown Sources"
   - Tap the APK to install

## ⚡ Build Status

Check if the latest build succeeded:
- Green ✅ = Build successful, APK available
- Red ❌ = Build failed, check logs
- Yellow 🟡 = Build in progress

## 📦 What Gets Built

Each successful build creates:
- **APK file** (app-release.apk) - Ready to install
- **App Bundle** (app-release.aab) - For Play Store
- **Release notes** - Build information

## 🎯 Next Steps

### For End Users
- Download the APK from artifacts
- Install on your Android device
- Start using the app!

### For Developers
- Push code to trigger builds
- Download artifacts to test
- Review build logs for issues

### For Deployment
- See [DEPLOYMENT_GUIDE.md](../DEPLOYMENT_GUIDE.md) for store deployment
- Configure secrets for automated deployment
- Set up signing keys

## ❓ Common Questions

**Q: Where is the APK file?**
A: Actions → Latest run → Artifacts → android-apk-release

**Q: How long are artifacts kept?**
A: 30 days from the build date

**Q: Can I build manually?**
A: Yes! Actions → Build and Deploy → Run workflow

**Q: How do I deploy to Play Store?**
A: See DEPLOYMENT_GUIDE.md for setup instructions

**Q: Build failed, what now?**
A: Click on the failed workflow run to see logs

## 🔗 Useful Links

- [Full Deployment Guide](../DEPLOYMENT_GUIDE.md)
- [Workflow Documentation](workflows/README.md)
- [GitHub Actions](https://github.com/KothariDhrumil/DandDSalesApp/actions)
- [Project README](../README.md)

---

Need help? Open an issue or contact the development team!
