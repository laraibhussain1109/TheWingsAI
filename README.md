# PayUI — Flutter Demo

A clean, modern UI prototype inspired by Paytm built with **Flutter (Dart)**. This repository contains a single-file prototype (`main.dart`) demonstrating login (phone + OTP mock), homepage (services, offers, wallet), and payment/recharge screens. It's aimed at quickly iterating on mobile UI and flows; you'll need to plug in real backends for OTP and payments for production use.

---

## Features

* Phone number login with OTP flow (mocked)
* Home screen with:

  * QR Quick Scan card (UI only)
  * Wallet card (balance, add money, send)
  * Money transfer shortcuts
  * Popular services and utilities
  * Offers carousel
* Recharge screen (mobile number, operator, amount)
* Payment confirmation screen with wallet/UPI mock
* Clean Material 3 styling and responsive cards

---

## Screenshots

*See the `assets` or the preview in your editor / emulator after running the app.*

---

## Requirements

* Flutter SDK (stable channel) installed — [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
* Android SDK / emulator or a connected Android device
* Recommended: Flutter 3.x or later

---

## Quick start

1. Create a new Flutter project (or use an existing one):

```bash
flutter create pay_ui_demo
cd pay_ui_demo
```

2. Replace `lib/main.dart` with the `main.dart` code from this prototype (or copy the canvas file content into your `lib/main.dart`).

3. Run the app:

```bash
flutter run
```

4. Use the phone login screen and enter a 10-digit number and a 4-digit OTP to navigate through the flows (OTP is mocked in this prototype).

---

## Project Structure (single-file prototype)

* `lib/main.dart` — Single-file demo containing UI for login, OTP, home, recharge, and payment screens.

> Note: This is intentionally a single-file prototype for fast iteration. For a real app, break components into multiple files and add state management (Provider / Riverpod / Bloc).

---

## Integrating Real Services

### OTP Integration

* Replace the mocked OTP flow with a real provider such as Firebase Auth (Phone Auth) or Twilio Verify.
* Add server-side verification when required and secure your API keys using environment variables or secure storage.

Helpful links:

* Firebase Phone Auth: [https://firebase.flutter.dev/docs/auth/phone](https://firebase.flutter.dev/docs/auth/phone)
* Twilio Verify API docs

### Payment Integration

* Integrate payment SDKs for production transactions (Razorpay, Paytm SDK, Google Pay / UPI intents).
* Make sure to follow the payment provider’s test and production flow and secure your merchant/account keys.

---

## Recommended Improvements

* Split UI into smaller widgets and pages
* Add navigation state handling (named routes or navigator 2.0)
* Add persistent user/session storage (SharedPreferences / Secure Storage)
* Implement real OTP and payment gateways
* Add unit/widget tests and CI for automated checks
* Add localization and theming

---

## Contributing

This is intended as a starting UI prototype. Contributions are welcome — open issues for features you want, or submit PRs to:

* Split components into files
* Add Firebase/Twilio example integration (with environment variables)
* Add payment gateway wiring examples (Razorpay / UPI)

---

## License

MIT License — feel free to reuse and modify for personal or commercial projects.

