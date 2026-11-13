# Al-Barkat Fruit Mandi — Project History & Summary

## 1. Project Links & Deliverables
- **Local Flutter Project**: `C:\Users\Haseeb\Desktop\fruit_mandi_flutter`
- **GitHub Repository (`master`)**: https://github.com/Haseeb-ML/fruit-mandi-flutter
- **Firebase Project**: `albarkat-fruit-mandi` ([Firebase Console](https://console.firebase.google.com/project/albarkat-fruit-mandi/overview))
  - **Web App ID**: `1:190917926140:web:f4afd4dd5c6a1d116d8b79`
  - **Android App ID**: `1:190917926140:android:5b06999323e5434f6d8b79` (`com.albarkat.fruit_mandi_app`)
- **Live Web Preview (Firebase Hosting)**: https://albarkat-fruit-mandi.web.app
- **Android Release APK**: `C:\Users\Haseeb\Desktop\AlBarkat_FruitMandi.apk`
- **Vercel Config**: `vercel.json` added (`build/web` ready; requires `npx vercel login` to deploy)

---

## 2. Chronological Git & Development History

| Commit | Summary |
| --- | --- |
| `b0797ab` | **Initial commit**: Created pure Flutter Android project (`Al-Barkat Commission Agents` / Fruit Mandi Arhti System) matching reference screenshots, built initial release APK, and pushed to GitHub. |
| `567a7b1` | **Mobile layout & E2E tests**: Fixed horizontal `RenderFlex` overflows across Login, Dashboard KPI & Quick Menu grids, Notifications, Farmers, Buyers, and Auction screens; added end-to-end widget tests (`test/widget_test.dart`). |
| `7c5c1af` | **100% test pass & overflow fixes**: Fixed remaining `RenderFlex` overflows in `buyers_screen.dart` (`Outstanding / کریڈٹ` row), `arrival_screen.dart` (header row), and `auction_screen.dart` (`DropdownButtonFormField` `isExpanded: true`, metrics row, `_MetricCol` `FittedBox`). Verified `flutter analyze`, `flutter test`, and rebuilt release APK. |
| `7d8b34e` | **Weekly Sales graph fix**: Added missing `Commission:` and `Sales:` labels in the chart tooltip, positioned tooltip dynamically on left/right so it never covers the `Sat` peak dot, and added tap/drag gesture support across the graph (`Mon`–`Sun`). |
| `a7c2784` | **Quick Menu at top**: Moved the **Quick Menu** card to the top of `DashboardScreen` (above KPI cards, Weekly Sales, Top Fruits, and Recent Transactions) and updated `widget_test.dart`. |
| `485c55f` | **English & Urdu dual-language switcher**: Added `lib/l10n/app_lang.dart` (`AppLang` + `LanguageTogglePill`), `EN | اردو` toggle in `LoginScreen` and `AppBar`, and a **Language / زبان** selector card in `SettingsScreen` persisted in `MandiSettings.language`. |
| `1eb3cfe` | **Dedicated pages for all Quick Menu tools**: Created `lib/screens/quick_tools_screens.dart` with 6 full pages (`PaymentScreen`, `LedgerScreen`, `ExpensesScreen`, `ReportsScreen`, `InvoiceScreen`, `CashBookScreen`), lifted `AppLang` above `MaterialApp`, fixed `CashBookScreen`/`LedgerScreen` filter chip overflows with `Wrap`, and verified all 10 Quick Menu flows in `widget_test.dart`. |
| `ba52960` | **Firebase & Web support**: Split `LocalStore` into platform-safe `local_store.dart`, `local_store_io.dart`, and `local_store_stub.dart` for Web compatibility; created Firebase project `albarkat-fruit-mandi` with Web & Android apps (`google-services.json`, `lib/firebase_config.dart`, `firebase.json`, `.firebaserc`, `vercel.json`); built `build/web` and deployed live to Firebase Hosting. |
| `0f17450` | **Cleanup & verification**: Removed unused `dart:convert` import in `lib/models/mandi_models.dart`; verified `flutter analyze` (`No issues found!`) and `flutter test` (`All tests passed!`). |

---

## 3. App Modules & Features
- **Authentication**: `lib/screens/login_screen.dart` (mobile + password login UI, Remember Me, Forgot Password, `EN | اردو` toggle).
- **Dashboard**: `lib/screens/dashboard_screen.dart` (top **Quick Menu**, 6 KPI cards, interactive **Weekly Sales** line/area chart, **Top Fruits**, **Recent Transactions**).
- **Core Tabs**:
  - **Farmers** (`lib/screens/farmers_screen.dart`) — search, add, edit, delete with confirmation.
  - **Buyers** (`lib/screens/buyers_screen.dart`) — credit limit progress bar, search, add, edit, delete.
  - **Fruit Arrival** (`lib/screens/arrival_screen.dart`) — lot/weight/boxes tracking, add/edit/delete.
  - **Auction / Sale** (`lib/screens/auction_screen.dart`) — live commission & net calculation, auto-updates transactions.
  - **More / Settings** (`lib/screens/settings_screen.dart`) — Language switcher, company info, commission %, JSON backup/restore, reset demo, logout.
- **Quick Menu Dedicated Pages** (`lib/screens/quick_tools_screens.dart`):
  1. `PaymentScreen` (record buyer payments & view balances)
  2. `LedgerScreen` (filterable farmer & buyer party khata)
  3. `ExpensesScreen` (daily expense tracking & add modal)
  4. `ReportsScreen` (sales, commission, expenses, net profit, fruit breakdown)
  5. `InvoiceScreen` (formatted mandi bill preview & clipboard copy)
  6. `CashBookScreen` (credits/debits filter & full cash ledger)
- **Notifications**: `lib/screens/notifications_screen.dart` (unread badge, mark one / mark all read).

---

## 4. Latest Verified Checks
- `flutter analyze`: `No issues found! (ran in 6.4s)`
- `flutter test`: `All tests passed!` (2/2 tests in `test/widget_test.dart`)
- `flutter build web --release`: `Built build\web` (deployed to https://albarkat-fruit-mandi.web.app)
- `flutter build apk --release`: `Built build\app\outputs\flutter-apk\app-release.apk (47.6MB)`
