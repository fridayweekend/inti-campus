# INTI Campus

A Flutter Scaffold student project customised for INTI International University, using the supplied INTI logo and academic-block photograph.

## Run locally

Flutter 3.35.6 / Dart 3.9.2 is the tested version.

```powershell
cd "C:\Users\user\OneDrive\Desktop\inti scalfold"
flutter pub get
flutter run -d chrome
```

## Run in GitHub Codespaces

1. Upload this project's contents to a GitHub repository. Include the hidden `.devcontainer` and `.github` folders, along with `pubspec.lock`, `lib`, `assets`, `web`, and `test`. Do not upload `build`, `.dart_tool`, or machine-specific files.
2. Select **Code > Codespaces > Create codespace on main**. The included dev container installs Flutter; no local Flutter installation is required. The initial container build can take several minutes.
3. In the Codespaces terminal, run these as TWO separate commands:

```bash
flutter pub get
flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0
```

4. Open port 8080 from the **Ports** tab. Keep the terminal running. After source edits, restart the running web-server command and refresh the browser if needed.

## Publish on GitHub Pages

The included `.github/workflows/web-deploy.yml` builds, checks and deploys the app on each push to `main`, or when run manually from Actions.

1. Push the project to your GitHub repository on `main`.
2. In **Settings > Pages > Build and deployment > Source**, select **GitHub Actions**.
3. Open **Actions > Deploy Flutter Web to Pages > Run workflow** if the initial push happened before Pages was enabled.
4. When the workflow succeeds, the `github-pages` environment and Settings > Pages show your live URL, normally `https://YOUR_USERNAME.github.io/YOUR_REPO/`.

This workflow uses GitHub's official Pages artifact deployment. You do not need a `gh-pages` branch. The base path comes from `configure-pages`, so no repository-name placeholder needs editing. Repository Pages availability depends on your GitHub plan and repository visibility.

The normal JavaScript web release is used for compatibility. Wasm is opt-in with `--wasm`; it is not required for GitHub Pages. This app switches sections inside one Scaffold and has no path-based router, so it does not need an index-to-404 workaround.

References: https://docs.flutter.dev/deployment/web and https://docs.github.com/en/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages

## Features and assignment mapping

| Requirement | Implementation |
| --- | --- |
| Scaffold, AppBar and body | CampusShell with INTI logo, title and working announcements button |
| Three main pages | Home, Activities and Profile |
| BottomNavigationBar | currentIndex, onTap and setState change the section |
| Drawer and DrawerHeader | Student information, three navigation items, Help and About |
| Meaningful FloatingActionButton | Adds a validated reminder, then displays it on Home |
| SnackBar | Reminder creation/completion, save, join/cancel and profile updates |
| State management | setState updates navigation, reminders, profile, filters and activity state |
| Three activities | Technology workshop, sports afternoon and community night |
| At least two service cards | Library and Student support, both with information dialogs |
| Student profile | Editable name, ID, programme and email with validation |
| Customisation | INTI red theme, supplied images, AppBar, drawer, dashboard, event cards, service cards, typography, icons, reminders and custom messages |
| Additional interactions | Search activities, saved-only filter, save/unsave, join/cancel, complete reminders |

## Demonstrate the app

1. Home shows the campus photo, student greeting, counters and service cards.
2. Open the drawer and navigate to Activities.
3. Save an activity, turn on Saved only, then join the activity. Profile shows the joined activity.
4. Add a reminder using the floating button. Home updates and a SnackBar confirms it. Scroll to My reminders and complete it.
5. Edit the profile. The greeting and drawer update to reflect the new name.
6. Tap the notification icon to open the noticeboard.

## Checks

```bash
flutter analyze
flutter test
flutter build web --release
```

Widget tests cover navigation, registration, saved filtering, reminder validation and completion, profile editing, drawer navigation, and layout at 320, 390 and 1280 logical pixels.

## Project files

- `lib/main.dart`: complete, readable implementation and form dialog.
- `assets/`: local images packaged with the app.
- `test/widget_test.dart`: behaviour and layout checks.
- `web/`: browser entry point and manifest.
- `android/`: generated Android runner (Android SDK required to build).
- `.devcontainer/`: Codespaces environment with Flutter preinstalled.
- `.github/workflows/web-deploy.yml`: automated Pages build and deployment.

All student details, activities, dates, venues and notices are fictional demonstration content. This is an unofficial educational app. Registrations do not contact the university. State is held in memory and resets on refresh/restart. No authentication, database or background notification service is included. Your original image files remain in the project root; the app uses copies in `assets/`.
