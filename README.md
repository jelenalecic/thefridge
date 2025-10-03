# TheFridge

Flutter app for tracking fridge items.  
Built for the Hylastix candidate test – focus on **frontend**.

---

## What it does
- Track items by added date and best-before date
- Categories with icons
- Filter and sort (expiring soon / expired / fresh)
- Item details in a simple dialog
- Light / dark theme support

---

## Demo
👉 [YouTube video](https://www.youtube.com/watch?v=3TpIgeU3PTM)

[![Watch the demo](https://img.youtube.com/vi/3TpIgeU3PTM/0.jpg)](https://www.youtube.com/watch?v=3TpIgeU3PTM)

---

## Tech
- **Flutter (Dart)**
- **Riverpod** for state management
- **SharedPreferences** as local persistence (fake backend)
- **Font Awesome** for icons
- Simple theming system (light/dark)

---

## GitHub workflow
- Work split into feature branches
- Pull requests used for merging
- Clear history of incremental changes

I also added a simple GitHub Actions workflow (**Flutter CI**) which runs on each push/PR:
- installs Flutter
- fetches dependencies
- runs `flutter analyze`
- checks formatting with `dart format --set-exit-if-changed .`

This ensures the repo stays clean and consistent.

---

## Run locally
```bash
flutter pub get
flutter run
